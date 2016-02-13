#
# Copyright (c) 2013-2015 SKYARCH NETWORKS INC.
#
# This software is released under the MIT License.
#
# http://opensource.org/licenses/mit-license.php
#

require 'pp'
require 'highline'

class CoolLogFormater
  include ActiveSupport::TaggedLogging::Formatter

  Colors = {
    'FATAL' => :red,
    'ERROR' => :red,
    'WARN'  => :yellow,
    'INFO'  => :green,
    'DEBUG' => :blue,
  }

  @@highline = HighLine.new

  def call(severity, timestamp, _progname, msg)
    message = if msg.is_a?(String) then
                return '' if msg.empty?
                msg
              else
                msg.pretty_inspect
              end
    time  = "[#{timestamp.strftime("%y/%m/%d %H:%M:%S" )}.#{'%06d' % timestamp.usec.to_s}]"
    level = "[#{@@highline.color(severity, Colors[severity], :bold)}]:"

    level << ' ' if severity == 'WARN' or severity == 'INFO'

    "#{time} #{level} #{message}\n"
  end
end

Rails.logger.formatter = CoolLogFormater.new
