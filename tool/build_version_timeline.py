"""Build the version-history PDF from docs/VERSION_TIMELINE.md.

Requires reportlab. Optional preview rendering requires pymupdf and Pillow.
"""
from __future__ import annotations

import argparse
import html
import os
import re
from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import PageBreak, Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "docs" / "VERSION_TIMELINE.md"
OUTPUT = ROOT / "dist" / "Ryser_Version_Timeline_V1_V4.pdf"
INK = colors.HexColor("#17231D")
GREEN = colors.HexColor("#145E35")
MUTED = colors.HexColor("#58665E")
FONT, BOLD = "Helvetica", "Helvetica-Bold"
font_dir = Path(os.environ.get("WINDIR", "C:/Windows")) / "Fonts"
if (font_dir / "segoeui.ttf").exists() and (font_dir / "seguisb.ttf").exists():
    pdfmetrics.registerFont(TTFont("TimelineSans", str(font_dir / "segoeui.ttf")))
    pdfmetrics.registerFont(TTFont("TimelineBold", str(font_dir / "seguisb.ttf")))
    pdfmetrics.registerFontFamily("TimelineSans", normal="TimelineSans", bold="TimelineBold")
    FONT, BOLD = "TimelineSans", "TimelineBold"


def markup(text: str) -> str:
    text = html.escape(text)
    text = re.sub(r"\*\*(.+?)\*\*", r"<b>\1</b>", text)
    return re.sub(r"`([^`]+)`", r"\1", text)


STYLES = {
    "title": ParagraphStyle("TimelineTitle", fontName=BOLD, fontSize=27, leading=32,
                            textColor=INK, spaceAfter=10),
    "heading": ParagraphStyle("TimelineHeading", fontName=BOLD, fontSize=17, leading=22,
                              textColor=INK, spaceBefore=8, spaceAfter=10, keepWithNext=True),
    "subheading": ParagraphStyle("TimelineSubheading", fontName=BOLD, fontSize=11,
                                 leading=15, textColor=GREEN, spaceBefore=9,
                                 spaceAfter=5, keepWithNext=True),
    "body": ParagraphStyle("TimelineBody", fontName=FONT, fontSize=10, leading=14,
                           textColor=INK, spaceAfter=7),
    "bullet": ParagraphStyle("TimelineBullet", fontName=FONT, fontSize=10, leading=14,
                             textColor=INK, leftIndent=10, firstLineIndent=-8, spaceAfter=5),
    "cell": ParagraphStyle("TimelineCell", fontName=FONT, fontSize=8.8, leading=12,
                           textColor=INK),
    "header": ParagraphStyle("TimelineHeader", fontName=BOLD, fontSize=8.8, leading=12,
                             textColor=colors.white),
}


def decorate(canvas, doc):
    width, height = A4
    canvas.saveState()
    canvas.setFont(BOLD, 8)
    canvas.setFillColor(GREEN)
    canvas.drawString(16 * mm, height - 11 * mm, "RYSER  |  VERSION HISTORY")
    canvas.setFillColor(MUTED)
    canvas.setFont(FONT, 8)
    canvas.drawString(16 * mm, 10 * mm, "V1 to V3 history  /  V4 proposal")
    canvas.drawRightString(width - 16 * mm, 10 * mm, str(doc.page))
    canvas.restoreState()


def add_table(lines, story, available_width):
    rows = [[cell.strip() for cell in line.strip().strip("|").split("|")] for line in lines]
    rows = [row for row in rows if not all(re.fullmatch(r"[:\- ]+", cell) for cell in row)]
    count = len(rows[0])
    if count == 2:
        ratios = [0.14, 0.86] if rows[0][0] == "Stage" else [0.35, 0.65]
    elif rows[0][0] == "Order":
        ratios = [0.20, 0.43, 0.37]
    elif rows[0][0] == "Reported problem":
        ratios = [0.31, 0.40, 0.29]
    else:
        ratios = [0.25, 0.37, 0.38]
    data = [[Paragraph(markup(cell), STYLES["header" if i == 0 else "cell"])
             for cell in row] for i, row in enumerate(rows)]
    table = Table(data, colWidths=[available_width * ratio for ratio in ratios],
                  repeatRows=1, hAlign="LEFT")
    table.setStyle(TableStyle([
        ("BACKGROUND", (0, 0), (-1, 0), GREEN),
        ("ROWBACKGROUNDS", (0, 1), (-1, -1), [colors.HexColor("#F0F6F2"), colors.white]),
        ("VALIGN", (0, 0), (-1, -1), "TOP"),
        ("LEFTPADDING", (0, 0), (-1, -1), 7),
        ("RIGHTPADDING", (0, 0), (-1, -1), 7),
        ("TOPPADDING", (0, 0), (-1, -1), 6),
        ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
        ("LINEBELOW", (0, 0), (-1, 0), 0.5, GREEN),
    ]))
    story.extend([table, Spacer(1, 9)])


def build():
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    doc = SimpleDocTemplate(str(OUTPUT), pagesize=A4, rightMargin=16 * mm,
                           leftMargin=16 * mm, topMargin=19 * mm, bottomMargin=18 * mm,
                           title="Ryser Version Timeline", author="", subject="V1 to V3 history and proposed V4 plan")
    lines = SOURCE.read_text(encoding="utf-8").splitlines()
    story, index = [], 0
    while index < len(lines):
        line = lines[index].strip()
        index += 1
        if not line:
            continue
        if line == "<!-- pagebreak -->":
            story.append(PageBreak())
            continue
        if line.startswith("|"):
            table_lines = [line]
            while index < len(lines) and lines[index].strip().startswith("|"):
                table_lines.append(lines[index].strip())
                index += 1
            add_table(table_lines, story, doc.width)
            continue
        if line.startswith("# "):
            story.append(Paragraph(markup(line[2:]), STYLES["title"]))
            continue
        if line.startswith("## "):
            story.append(Paragraph(markup(line[3:]), STYLES["heading"]))
            continue
        if line.startswith("### "):
            story.append(Paragraph(markup(line[4:]), STYLES["subheading"]))
            continue
        bullet = line.startswith("- ") or re.match(r"^\d+\. ", line)
        while index < len(lines) and lines[index].strip() and not re.match(
                r"^(#|\||<!--|- |\d+\. )", lines[index].strip()):
            line += " " + lines[index].strip()
            index += 1
        if line.startswith("- "):
            line = "\u2022 " + line[2:]
        story.append(Paragraph(markup(line), STYLES["bullet" if bullet else "body"]))
    doc.build(story, onFirstPage=decorate, onLaterPages=decorate)
    print(OUTPUT)


def preview():
    import pymupdf
    from PIL import Image, ImageDraw

    directory = ROOT / "artifacts" / "version-timeline-pages"
    directory.mkdir(parents=True, exist_ok=True)
    pdf = pymupdf.open(OUTPUT)
    thumbnails = []
    for index, page in enumerate(pdf):
        path = directory / f"page-{index + 1}.png"
        page.get_pixmap(matrix=pymupdf.Matrix(1.5, 1.5)).save(path)
        image = Image.open(path).convert("RGB")
        image.thumbnail((350, 495))
        tile = Image.new("RGB", (370, 525), "#d6ded8")
        tile.paste(image, ((370-image.width)//2, 8))
        ImageDraw.Draw(tile).text((12, 507), f"Page {index + 1}", fill="black")
        thumbnails.append(tile)
        body_lines = page.get_text().splitlines()
        print(f"Page {index + 1}: {len(page.get_text().split())} words; "
              f"first heading: {body_lines[1] if len(body_lines)>1 else ''}")
    sheet = Image.new("RGB", (370 * 4, 525 * ((len(thumbnails) + 3)//4)), "white")
    for index, tile in enumerate(thumbnails):
        sheet.paste(tile, ((index % 4)*370, (index//4)*525))
    sheet.save(directory / "contact-sheet.png")
    print(f"Pages: {len(pdf)}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--preview", action="store_true")
    args = parser.parse_args()
    build()
    if args.preview:
        preview()
