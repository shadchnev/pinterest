$(document).ready(function() {
  $('img').click(function(event) {
    var asin = $(event.target).attr('data');
    var base = "http://pinterest.com/pin/create/bookmarklet/?"
    var imageUrl = $(event.target).attr('src');
    var websiteUrl = "http://beautifulthings.herokuapp.com/" + asin;
    var vars = [];
    vars.push("media=" + escape(imageUrl));
    vars.push("url=" + escape(websiteUrl));
    vars.push("alt=alt");
    vars.push("title=Beautiful gift");
    vars.push("is_video=false");
    var url = base + vars.join("&");
    params = "status=no,resizable=no,scrollbars=yes,personalbar=no,directories=no,location=no,toolbar=no,menubar=no,width=632,height=270,left=0,top=0";
    window.open(url, "Pinterest", params)
  })
})