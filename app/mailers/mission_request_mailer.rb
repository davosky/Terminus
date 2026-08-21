class MissionRequestMailer < ApplicationMailer
  def validation_request(mission_request, validator)
    return if validator.email.blank?

    @mission_request = mission_request
    @validator = validator
    token = mission_request.signed_id(expires_in: 30.days, purpose: "mission_request_validation")
    @approve_url = approve_form_mission_request_validation_url(token: token)
    @reject_url = reject_form_mission_request_validation_url(token: token)

    mail(
      to: validator.email,
      subject: "Richiesta di approvazione missione - #{mission_request.user.first_name} #{mission_request.user.last_name}"
    )
  end

  def approved(mission_request, reimbursement)
    return if mission_request.user.email.blank?

    @mission_request = mission_request
    @reimbursement = reimbursement

    mail(to: mission_request.user.email, subject: "Richiesta missione approvata")
  end

  def rejected(mission_request)
    return if mission_request.user.email.blank?

    @mission_request = mission_request

    mail(to: mission_request.user.email, subject: "Richiesta missione respinta")
  end
end
