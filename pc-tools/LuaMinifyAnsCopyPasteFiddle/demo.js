String.prototype.snap = function (n) {
    var ret = ""
    var i=0
    while(i<this.length){
        ret += this.substr(i,n)
        ret += "\n\n"
        i+=128
    }
    return ret
};

function dof(){
    try {
        $("#out").val("brb...")
        $("#out").val(('r s=string.char(32)shell.run("r","'+
                    luamin.minify($("#in").val())
                     .replace(/\\/g,'\\\\')
                     .replace(/\"/g,'\\"')
                     .replace(/ /g,'"..s.."')
                     .replace(/\n/g,'\\n')
                     +
                    '")'
                ).snap(128)
               )
    } catch (e) {
        $("#out").val(e)
    }
}

dof()

$("#do").click(dof)

$("#in").keyup(dof)
