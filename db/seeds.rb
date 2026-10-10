# Fake credentials, safe for a public repo. Real development users are created by hand.
User.find_or_create_by!(username: "utente") do |user|
  user.email = "utente@example.com"
  user.password = "pAssword1234567"
  user.first_name = "Utente"
  user.last_name = "Prova"
  user.gender = "A"
  user.region = "FVG"
  user.province = "TS"
  user.institute = "Istituto"
  user.office = "Ufficio"
  user.regular = true
end
