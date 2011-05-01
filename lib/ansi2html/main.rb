require 'strscan'

module ANSI2HTML
  class Main
    COLOR = {
       '1' => 'bold',
      '30' => 'black',
      '31' => 'red',
      '32' => 'green',
      '33' => 'yellow',
      '34' => 'blue',
      '35' => 'magenta',
      '36' => 'cyan',
      '37' => 'white',
      '90' => 'grey'
    }
    
    def self.execute
      new(STDIN.read, STDOUT, ARGV.index('--envelope'), ARGV.index('--dark'))
    end

    def initialize(ansi, out, envelope=false, dark=false)
      if(envelope)
        out.print %{<!doctype html>
<html>
<head>
  <meta charset="utf-8" />
  <style>
    .bold {
      font-weight: bold;
    }
    .black {
      color: black;
    }
    .red {
      color: red;
    }
    .green {
      color: green;
    }
    .yellow {
      color: yellow;
    }
    .blue {
      color: blue;
    }
    .magenta {
      color: magenta;
    }
    .cyan {
      color: cyan;
    }
    .white {
      color: white;
    }
    .grey {
      color: grey;
    }
  </style>
</head>
<body><pre><code>}
      end

      if dark
        out.puts "<div style='background-color: #111;padding:10px; color:#efefef'>"
      end

      ansi.gsub! /&/, "&amp;"
      ansi.gsub! /</, "&lt;"
      ansi.gsub! />/, "&gt;"
      s = StringScanner.new(ansi)
      tags_opened = 0
      while(!s.eos?)
        if s.scan(/\e\[(3[0-7]|90|1)m/)
          out.print(opening_tag COLOR[s[1]])
          tags_opened += 1
        else
          if s.scan(/\e\[0?m/)
            if tags_opened > 0
              out.print(%{</span>})
              tags_opened -= 1
            else
              out.print('')
            end
          else
            out.print(s.scan(/./m))
          end
        end
      end

      if dark
        out.print "</div>" 
      end

      if(envelope)
        out.print %{</code></pre></body></html>}
      end
    end

    def opening_tag color
      %{<span class="#{color}" style="#{to_css color}">}
    end

    def closing_tag
      "</span>" 
    end

    def to_css(color)
      case color
      when 'bold'
        "font-weight:bold"
      else
        "color:#{color}" 
      end
    end
  end
end
