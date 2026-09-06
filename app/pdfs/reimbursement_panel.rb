# Shared geometry, styling and formatting helpers for the two panels printed
# side by side on each A4 landscape reimbursement page. Coordinates are given in
# millimetres from the top-left corner of the panel.
class ReimbursementPanel
  WIDTH = 128.38
  LINE_HEIGHT = 5.14
  BODY_SIZE = 11
  HEADING_SIZE = 12
  SIGNATURE_HEIGHT = 11.52
  ACCENT_COLOR = "ff4136"
  CARD_INSET = 0.35
  CARD_RADIUS = 1.38
  CARD_BAR = 1.16
  RULE_DASH = 0.8

  def initialize(pdf, reimbursement, origin)
    @pdf = pdf
    @reimbursement = reimbursement
    @origin = origin
  end

  private

  attr_reader :pdf, :reimbursement, :origin

  def user
    reimbursement.user
  end

  def full_name
    "#{user.first_name} #{user.last_name}"
  end

  # Rounded outline of a printed sheet, with the accent bar running along its
  # rounded left edge. Left unfilled, so that a signature written across it stays
  # readable.
  def card(top, height)
    pdf.stroke_color ACCENT_COLOR
    pdf.stroke_rounded_rectangle([ x(CARD_INSET), y(top) ],
      (WIDTH - 2 * CARD_INSET).mm, height.mm, CARD_RADIUS.mm)
    draw_accent_bar(top, height)
    pdf.fill_color "000000"
    pdf.stroke_color "000000"
  end

  def draw_accent_bar(top, height)
    left = x(CARD_INSET)
    right = x(CARD_INSET + CARD_BAR)
    pdf.fill_color ACCENT_COLOR
    pdf.fill do
      pdf.move_to right, y(top)
      pdf.line_to right, y(top + height)
      pdf.curve_to [ left, y(top + height - CARD_RADIUS) ],
        bounds: [ [ right, y(top + height + 0.65) ], [ left, y(top + height - 0.62) ] ]
      pdf.line_to left, y(top + CARD_RADIUS)
      pdf.curve_to [ right, y(top) ],
        bounds: [ [ left, y(top + 0.62) ], [ right, y(top - 0.65) ] ]
    end
  end

  def line(top, segments, size: BODY_SIZE, indent: 0)
    pdf.formatted_text_box(segments, at: [ x(indent), y(top) ], width: (WIDTH - indent - CARD_INSET).mm,
      height: size * 1.25, size: size, overflow: :shrink_to_fit)
  end

  def dashed_line(top, length, indent: 0)
    pdf.dash(RULE_DASH.mm, space: RULE_DASH.mm)
    pdf.stroke_horizontal_line(x(indent), x(indent + length), at: y(top))
    pdf.undash
  end

  # Signature caption: the date sits in its own column, as on the printed form.
  def date_column(top, value, label_x:, value_x:)
    line(top, [ italic("Data:") ], indent: label_x)
    line(top, [ bold(date(value)) ], indent: value_x)
  end

  def signature(top, uploader, indent: 0)
    return if uploader.blank? || uploader.path.blank? || !File.exist?(uploader.path)

    pdf.image uploader.path, at: [ x(indent), y(top) ], height: SIGNATURE_HEIGHT.mm
  end

  def x(offset)
    (origin + offset).mm
  end

  def y(top)
    pdf.bounds.top - top.mm
  end

  def euro(amount)
    "€ #{decimal(amount)}"
  end

  def decimal(amount)
    ActiveSupport::NumberHelper.number_to_rounded(amount || 0, precision: 2, locale: :it)
  end

  def date(value)
    value&.strftime("%d/%m/%Y")
  end

  def institute
    { text: user.institute.to_s, styles: [ :bold ], color: ACCENT_COLOR }
  end

  def bold(text)
    { text: text.to_s, styles: [ :bold ] }
  end

  # Fixed wording is set in italics, so that it reads apart from the values the
  # user filled in.
  def italic(text)
    { text: text.to_s, styles: [ :italic ] }
  end

  def plain(text)
    { text: text.to_s }
  end
end
