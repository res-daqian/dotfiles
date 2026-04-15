#!/usr/bin/env python3

from __future__ import annotations

import sys
import zipfile
import xml.etree.ElementTree as ET
from pathlib import PurePosixPath

NS_MAIN = "http://schemas.openxmlformats.org/spreadsheetml/2006/main"
NS_REL = "http://schemas.openxmlformats.org/package/2006/relationships"
NS_DOC_REL = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
MAX_ROWS_PER_SHEET = 200
MAX_COLS = 40


def qname(namespace: str, name: str) -> str:
    return f"{{{namespace}}}{name}"


def normalize_target(target: str) -> str:
    if target.startswith("/"):
        return target.lstrip("/")
    if target.startswith("xl/"):
        return target
    return str(PurePosixPath("xl") / PurePosixPath(target))


def shared_string_text(node: ET.Element) -> str:
    return "".join(text or "" for text in node.itertext()).strip()


def load_shared_strings(archive: zipfile.ZipFile) -> list[str]:
    try:
        root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
    except KeyError:
        return []

    items: list[str] = []
    for item in root.findall(qname(NS_MAIN, "si")):
        items.append(shared_string_text(item))
    return items


def load_sheets(archive: zipfile.ZipFile) -> list[tuple[str, str]]:
    workbook = ET.fromstring(archive.read("xl/workbook.xml"))
    rels = ET.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
    rel_by_id = {
        rel.get("Id", ""): normalize_target(rel.get("Target", ""))
        for rel in rels.findall(qname(NS_REL, "Relationship"))
    }

    sheets: list[tuple[str, str]] = []
    for sheet in workbook.findall(f".//{qname(NS_MAIN, 'sheet')}"):
        sheet_id = sheet.get(f"{{{NS_DOC_REL}}}id", "")
        sheets.append((sheet.get("name", "Sheet"), rel_by_id.get(sheet_id, "")))
    return sheets


def column_index(cell_ref: str) -> int:
    letters = "".join(ch for ch in cell_ref if ch.isalpha()).upper()
    if not letters:
        return 0

    index = 0
    for char in letters:
        index = index * 26 + ord(char) - 64
    return max(index - 1, 0)


def cell_value(cell: ET.Element, shared_strings: list[str]) -> str:
    cell_type = cell.get("t", "")
    raw = cell.findtext(qname(NS_MAIN, "v"), default="").strip()

    if cell_type == "s":
        try:
            return shared_strings[int(raw)]
        except (ValueError, IndexError):
            return ""
    if cell_type == "inlineStr":
        inline = cell.find(qname(NS_MAIN, "is"))
        return shared_string_text(inline) if inline is not None else ""
    if cell_type == "b":
        return "TRUE" if raw == "1" else "FALSE"
    if cell_type == "e":
        return f"#ERROR({raw})" if raw else "#ERROR"
    return raw


def preview_sheet(
    archive: zipfile.ZipFile, sheet_path: str, shared_strings: list[str]
) -> tuple[list[str], bool]:
    try:
        root = ET.fromstring(archive.read(sheet_path))
    except KeyError:
        return ["(Worksheet data is missing)"], False

    lines: list[str] = []
    truncated = False

    for row in root.findall(f".//{qname(NS_MAIN, 'row')}"):
        cells: dict[int, str] = {}
        for cell in row.findall(qname(NS_MAIN, "c")):
            idx = column_index(cell.get("r", "A1"))
            if idx >= MAX_COLS:
                continue

            value = " ".join(cell_value(cell, shared_strings).split())
            if value:
                cells[idx] = value

        if not cells:
            continue

        last_idx = max(cells)
        lines.append("\t".join(cells.get(i, "") for i in range(last_idx + 1)).rstrip())

        if len(lines) >= MAX_ROWS_PER_SHEET:
            truncated = True
            break

    if not lines:
        lines.append("(No visible cell data)")
    return lines, truncated


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: preview_xlsx.py <file>")
        return 0

    try:
        with zipfile.ZipFile(sys.argv[1]) as archive:
            shared_strings = load_shared_strings(archive)
            sheets = load_sheets(archive)

            if not sheets:
                print("Workbook has no sheets.")
                return 0

            for idx, (sheet_name, sheet_path) in enumerate(sheets, start=1):
                if idx > 1:
                    print()
                print(f"[Sheet {idx}] {sheet_name}")
                print("=" * (len(sheet_name) + 10))

                lines, truncated = preview_sheet(archive, sheet_path, shared_strings)
                for line in lines:
                    print(line)
                if truncated:
                    print(f"... truncated after {MAX_ROWS_PER_SHEET} rows")

    except Exception as exc:
        print(f"Unable to preview XLSX: {exc}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
