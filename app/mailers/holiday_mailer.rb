class HolidayMailer < ApplicationMailer
  def validation_request(holiday, director)
    return if director.email.blank?

    @holiday = holiday
    @director = director
    token = holiday.signed_id(expires_in: 30.days, purpose: "holiday_validation")
    @approve_url = approve_form_holiday_validation_url(token: token)
    @reject_url = reject_form_holiday_validation_url(token: token)

    mail(to: director.email, subject: "Richiesta di approvazione ferie - #{holiday.user.full_name}")
  end

  def approved(holiday)
    return if holiday.user.email.blank?

    @holiday = holiday

    mail(to: holiday.user.email, subject: "Richiesta ferie approvata")
  end

  def cancelled(director, details)
    return if director.email.blank?

    @director = director
    @details = details

    mail(to: director.email, subject: "Richiesta ferie annullata - #{details[:requester]}")
  end

  def rejected(holiday)
    return if holiday.user.email.blank?

    @holiday = holiday

    mail(to: holiday.user.email, subject: "Richiesta ferie respinta")
  end
end
