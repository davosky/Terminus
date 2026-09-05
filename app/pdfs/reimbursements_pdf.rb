require "prawn/measurement_extensions"

# Multi-page A4 landscape print of expense reimbursements: one reimbursement per
# page, split into a mission sheet (left) and an expense sheet (right) that are
# separated by a fold line.
class ReimbursementsPdf < Prawn::Document
  FONT_DIR = Rails.root.join("app/assets/fonts")
  HEADER_SVG = Rails.root.join("app/assets/images/reimbursements/reimbursements_print.svg")
  PANELS = [ [ 10, "Foglio Missione" ], [ 158, "Rimborso Spese" ] ].freeze
  FOLD_X = 148.5
  ICON_TOP = 10
  ICON_WIDTH = 10
  TITLE_TOP = 13
  RULE_TOP = 27.8
  LABEL_TOP = 30.3

  def initialize(reimbursements)
    super(page_size: "A4", page_layout: :landscape, margin: 0)
    register_fonts
    line_width 0.5

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
    PANELS.each { |origin, label| draw_panel_header(origin, label) }
    MissionSheetPanel.new(self, reimbursement, PANELS.first.first).draw
    ExpenseSheetPanel.new(self, reimbursement, PANELS.last.first).draw
  end

  def draw_fold_line
    dash(3, space: 3)
    stroke_vertical_line bounds.top, bounds.bottom, at: FOLD_X.mm
    undash
  end

  def draw_panel_header(origin, label)
    svg header_svg, at: [ origin.mm, top_at(ICON_TOP) ], width: ICON_WIDTH.mm, enable_web_requests: false
    formatted_text_box([ { text: "modulo ", styles: [ :italic ] }, { text: "Rimborsi Spese", styles: [ :bold ] } ],
      at: [ (origin + 12).mm, top_at(TITLE_TOP) ], width: 80.mm, height: 24, size: 15)
    stroke_horizontal_line origin.mm, (origin + ReimbursementPanel::WIDTH).mm, at: top_at(RULE_TOP)
    formatted_text_box([ { text: label, styles: [ :bold, :italic ] } ],
      at: [ origin.mm, top_at(LABEL_TOP) ], width: ReimbursementPanel::WIDTH.mm, height: 16, size: 10, align: :right)
  end

  def header_svg
    @header_svg ||= File.read(HEADER_SVG)
  end

  def top_at(offset)
    bounds.top - offset.mm
  end
end
