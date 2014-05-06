require 'nokogiri'

# usage: ruby formatHTML.rb hogehoge.html

data = File.read ARGV[0]
doc = Nokogiri::HTML.parse(data)

def printHTML(nodeList, depth)
  depth = depth + 1
  pad = " " * 2 * depth
  nodeList.each do |node|
    if(node.children().empty?())
      padPlusone = " " * 2 * (depth + 1)
      if(node.blank?())
        next
      elsif(node.name() == "text")
        print pad + node.content().strip + "\n"
      else
        print pad + node.to_html + "\n"
      end
      next
    else
      if(node.html?())
        attrHash = node.attributes()
        attrStr = ""
        attrHash.each do |key, value| 
          attrStr = attrStr + " "+ key + "=" + value
        end
        print pad + "<" + node.name() + " " + attrStr + ">" + "\n"
        printHTML(node.children(), depth)
        print pad + "</" + node.name() + ">" + "\n"
      elsif(node.element?())
        attrHash = node.attributes()
        attrStr = ""
        attrHash.each do |key, value| 
          attrStr = attrStr + " "+ key + "=" + value
        end
        print pad + "<" + node.name() + " " + attrStr + ">" + "\n"
        printHTML(node.children(), depth)
        print pad + "</" + node.name() + ">" + "\n"
      else
        printHTML(node.children(), depth)
      end
      next
    end
  end
end

printHTML(doc.root().children(), 0)
