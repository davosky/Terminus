# Terminus palette and font on top of Madmin's own stylesheet
Rails.application.config.after_initialize { Madmin.stylesheets << "madmin_terminus" }
