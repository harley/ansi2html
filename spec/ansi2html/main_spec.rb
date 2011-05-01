require 'stringio'
require 'ansi2html/main'

module ANSI2HTML
  describe Main do
    it "prints non-ansi as-is" do
      out = StringIO.new
      Main.new("Hello", out)
      out.string.should == 'Hello'
    end

    it "prints simply red" do
      out = StringIO.new
      Main.new("\e[31mHello\e[0m", out)
      out.string.should == '<span class="red">Hello</span>'
    end

    it "prints simply yellow" do
      out = StringIO.new
      Main.new("\e[33mHello\e[0m", out)
      out.string.should == '<span class="yellow">Hello</span>'
    end

    it "prints simply blue" do
      out = StringIO.new
      Main.new("\e[34mHello\e[0m", out)
      out.string.should == '<span class="blue">Hello</span>'
    end

    it "prints simply grey" do
      out = StringIO.new
      Main.new("\e[90mHello\e[0m", out)
      out.string.should == '<span class="grey">Hello</span>'
    end

    it "white bold boys have more fun" do
      out = StringIO.new
      Main.new("\e[37m\e[1mHello\e[0m\e[0m", out)
      out.string.should == '<span class="white"><span class="bold">Hello</span></span>'
    end

    it "should preserve < and > properly" do
      out = StringIO.new
      Main.new "\e[31mEmail me at Foo Bar <foo@bar.com>\e[0m", out
      out.string.should == '<span class="red">Email me at Foo Bar &lt;foo@bar.com&gt;</span>'
    end

    it "should escape html in code" do
      out = StringIO.new
      Main.new "\e[31m<h1 class='special' id=\"unique\">My title</h1>\e[0m", out
      out.string.should == "<span class=\"red\">&lt;h1 class='special' id=\"unique\"&gt;My title&lt;/h1&gt;</span>"
      
    end
  end
end
