require "prawn/measurement_extensions"

# Multi-page A4 landscape print of expense reimbursements: one reimbursement per
# page, split into a mission sheet (left) and an expense sheet (right) that are
# separated by a fold line.
class ReimbursementsPdf < Prawn::Document
  FONT_DIR = Rails.root.join("app/assets/fonts")
  IMAGE_DIR = Rails.root.join("app/assets/images/reimbursements")
  PANELS = [ [ 10, "Foglio Missione", "mission_sheet" ], [ 158.56, "Rimborso Spese", "expense_sheet" ] ].freeze
  FOLD_X = 148.5
  ICON_TOP = 10
  ICON_WIDTH = 10
  TITLE_X = 12.35
  TITLE_TOP = 10.8
  TITLE_SIZE = 18
  RULE_TOP = 22.75
  LABEL_TOP = 24.86
  LABEL_SIZE = 10
  GLYPH_TOP = 25.5
  GLYPH_WIDTH = 2.2
  GLYPH_GAP = 1.6

  def initialize(reimbursements)
    super(page_size: "A4", page_layout: :landscape, margin: 0)
    register_fonts
    line_width 0.2.mm

    reimbursements.each_with_index do |reimbursement, index|
      start_new_page unless index.zero?
      draw_page(reimbursement)
    end
  end

  private

  def register_fonts
    font_families.update("AsapCondensed" => {
      normal: FONT_DIR.join("AsapCondensed-Regular.ttf").to_s,
      italic: FONT_DIR.join("AsapCondensed-Italic.ttf").to_s,
      bold: FONT_DIR.join("AsapCondensed-Bold.ttf").to_s,
      bold_italic: FONT_DIR.join("AsapCondensed-BoldItalic.ttf").to_s
    })
    font "AsapCondensed"
  end

  def draw_page(reimbursement)
    draw_fold_line
    PANELS.each { |origin, label, glyph| draw_panel_header(origin, label, glyph) }
    MissionSheetPanel.new(self, reimbursement, PANELS.first.first).draw
    ExpenseSheetPanel.new(self, reimbursement, PANELS.last.first).draw
  end

  def draw_fold_line
    dash(3, space: 3)
    stroke_vertical_line bounds.top, bounds.bottom, at: FOLD_X.mm
    undash
  end

  def draw_panel_header(origin, label, glyph)
    draw_asset("icon", origin, ICON_TOP, ICON_WIDTH)
    formatted_text_box([ { text: "Rimborso Spese", styles: [ :bold, :italic ] } ],
      at: [ (origin + TITLE_X).mm, top_at(TITLE_TOP) ], width: 80.mm, height: 28, size: TITLE_SIZE)
    stroke_horizontal_line origin.mm, (origin + ReimbursementPanel::WIDTH).mm, at: top_at(RULE_TOP)
    draw_panel_label(origin, label, glyph)
  end

  def draw_panel_label(origin, label, glyph)
    formatted_text_box([ { text: label, styles: [ :bold, :italic ] } ],
      at: [ origin.mm, top_at(LABEL_TOP) ], width: ReimbursementPanel::WIDTH.mm, height: 16,
      size: LABEL_SIZE, align: :right)
    label_mm = width_of(label, size: LABEL_SIZE, style: :bold_italic) / 72 * 25.4
    glyph_x = origin + ReimbursementPanel::WIDTH - label_mm - GLYPH_GAP - GLYPH_WIDTH
    draw_asset(glyph, glyph_x, GLYPH_TOP, GLYPH_WIDTH)
  end

  def draw_asset(name, left, top, width)
    svg asset(name), at: [ left.mm, top_at(top) ], width: width.mm, enable_web_requests: false
  end

  def asset(name)
    @assets ||= {}
    @assets[name] ||= File.read(IMAGE_DIR.join("reimbursements_print_#{name}.svg"))
  end

  def top_at(offset)
    bounds.top - offset.mm
  end
end
