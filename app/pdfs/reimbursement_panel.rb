# Shared geometry, styling and formatting helpers for the two panels printed
# side by side on each A4 landscape reimbursement page. Coordinates are given in
# millimetres from the top-left corner of the panel.
class ReimbursementPanel
  WIDTH = 129
  LINE_HEIGHT = 5.3
  BODY_SIZE = 12
  HEADING_SIZE = 14
  SIGNATURE_HEIGHT = 11

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

  def line(top, segments, size: BODY_SIZE, indent: 0)
    pdf.formatted_text_box(segments, at: [ x(indent), y(top) ], width: (WIDTH - indent).mm,
      height: size * 1.25, size: size, overflow: :shrink_to_fit)
  end

  def dashed_line(top, length)
    pdf.dash(3, space: 3)
    pdf.stroke_horizontal_line(x(0), x(length), at: y(top))
    pdf.undash
  end

  def signature(top, uploader)
    return if uploader.blank? || uploader.path.blank? || !File.exist?(uploader.path)

    pdf.image uploader.path, at: [ x(0), y(top) ], height: SIGNATURE_HEIGHT.mm
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

  def bold(text)
    { text: text.to_s, styles: [ :bold ] }
  end

  def plain(text)
    { text: text.to_s }
  end
end
