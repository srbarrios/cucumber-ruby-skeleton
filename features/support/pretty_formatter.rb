require 'cucumber/formatter/pretty'

module CustomFormatter
  PrettyFormatter = PrependsFeatureName.formatter(Cucumber::Formatter::Pretty)
end
