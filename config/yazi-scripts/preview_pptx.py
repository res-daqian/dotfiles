#!/usr/bin/env python3

from __future__ import annotations

import re
import sys
import zipfile
import xml.etree.ElementTree as ET

NS_DRAWING = "http://schemas.openxmlformats.org/drawingml/2006/main"


def qname(namespace: str, name: str) -> str:
    return f"{{{namespace}}}{name}"


def slide_key(path: str) -> int:
    match = re.search(r"slide(\d+)\.xml$", path)
    return int(match.group(1)) if match else 0


def slide_text(data: bytes) -> list[str]:
    root = ET.fromstring(data)
    lines: list[str] = []

    for paragraph in root.iter(qname(NS_DRAWING, "p")):
        text = "".join(part.text or "" for part in paragraph.iter(qname(NS_DRAWING, "t")))
        text = " ".join(text.split())
        if text:
            lines.append(text)

    return lines


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: preview_pptx.py <file>")
        return 0

    try:
        with zipfile.ZipFile(sys.argv[1]) as archive:
            slides = sorted(
                (
                    name
                    for name in archive.namelist()
                    if name.startswith("ppt/slides/slide")
                    and name.endswith(".xml")
                    and "/_rels/" not in name
                ),
                key=slide_key,
            )

            if not slides:
                print("Presentation has no slides.")
                return 0

            for idx, slide in enumerate(slides, start=1):
                if idx > 1:
                    print()
                print(f"[Slide {idx}]")
                print("=========")

                lines = slide_text(archive.read(slide))
                if not lines:
                    print("(No text found on this slide)")
                    continue

                for line in lines:
                    print(line)

    except Exception as exc:
        print(f"Unable to preview PPTX: {exc}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
