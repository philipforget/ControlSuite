#! /bin/bash
mxmlc -load-config+=obj/flex-config.xml -debug=true -incremental=true -benchmark=false -o bin/Main.swf && cp bin/Main.swf /home/www/sequence.chevalierforget.com/static/swf/sequence.swf
