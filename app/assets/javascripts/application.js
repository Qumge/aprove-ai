// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

// This file includes the common AdminLTE JS files that is commonly used on every page
//= require jquery
//= require dist/adminlte
//= require dist/adminlte_extra
//= require dashboard_v1
//= require plupload/js/moxie
//= require plupload/js/plupload.dev
//= require select2-full
//= require icheck
//= require externals/Chart
//= require my_chat

$.fn.datepicker.dates['zh-cn'] = {
    days: ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
    daysShort: ["日", "一", "二", "三", "四", "五", "六"],
    daysMin: ["日", "一", "二", "三", "四", "五", "六"],
    months: ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"],
    monthsShort: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"],
    today: "今天",
    clear: "清除",
    format: "yyyy-mm-dd",
    titleFormat: "yyyy年 MM", /* Leverages same syntax as 'format' */
    weekStart: 0
};
var initPage = function () {
    $(".modal").on("hidden.bs.modal", function() {
        $(this).removeData("bs.modal");
    });
    textToImg();
    $.fn.modal.Constructor.prototype.enforceFocus = function () { };
    $('.todo-list').todoList({
        onCheck  : function () {
        },
        onUnCheck: function () {
        }
    });
    $('.datepicker').datepicker({
        autoclose: true,
        language: 'zh-cn'
    });

};

function show_flash(type, message){
    $(".page_tips").fadeIn(function(){
        setTimeout(function(){
            $(".page_tips").fadeOut();
            $(".page_tips").html('');
        }, 3000);
    });
    $(".page_tips").append(
        '<div class="' + type +'"> <div class="inner">'+ message + '<i class="fa fa-close close-tips"></i> </div> </div>');
}


// Preview supported documents in the file modal.
function show_file(e){
    var filename = $(e).attr('data-file-name');
    var url = $(e).attr('data-url');
    var ext = filename.split('.').pop().toLowerCase();
    var preview;
    $('#file-modal-label').text($(e).attr('data-file-name'));
    if(['docx', 'doc', 'ppt', 'pptx', 'xls', 'xlsx'].indexOf(ext) >= 0){
        preview = $('<iframe>', {
            src: 'https://view.officeapps.live.com/op/embed.aspx?src=' + encodeURIComponent(url),
            width: '100%',
            height: '100%',
            frameborder: 0
        });
    }else if(['pdf'].indexOf(ext) >= 0){
        preview = $('<iframe>', {src: url, width: '100%', height: '100%', frameborder: 0});
    }else if(['png', 'jpg', 'jpeg', 'gif', 'bmp'].indexOf(ext) >= 0){
        preview = $('<div>').css('text-align', 'center').append(
            $('<img>', {src: url, alt: filename}).css('max-width', '90%')
        );
    }else{
        alert('该文件格式暂时不支持在线预览，点击确定后直接下载文件。');
        location.href = url;
        return;
    }
    $('#file-modal-body').empty().append(preview);
    $('#file-modal').modal();
}

function textToImg() {
    var fontSize = 500;
    var fontWeight = 'bold';
    var canvases = document.getElementsByClassName('canvas');
    for (var i = 0; i < canvases.length; i++) {
        var canvas = canvases[i];
        canvas.width = 1000;
        canvas.height = 1000;
        var context = canvas.getContext('2d');
        context.fillStyle = '#F7F7F9';
        context.fillRect(0, 0, canvas.width, canvas.height);
        context.fillStyle = '#605CA8';
        context.font = fontWeight + ' ' + fontSize + 'px sans-serif';
        context.textAlign = 'center';
        context.textBaseline = "middle";
        var name = $(canvas).attr('first_name');
        context.fillText(name, fontSize, fontSize);
        $(canvas).siblings('img').attr('src', canvas.toDataURL("image/png"));
    }

};



$(document).ready(initPage);
$(document).on("turbolinks:load", initPage);



function showSpinner() {
    $("#spinner").addClass("spinner");
}

function hideSpinner() {
    $("#spinner").removeClass("spinner");
}

function StorageUploader(options) {
    this.options = options || {};
    this.file = null;
    this.input = document.createElement('input');
    this.input.type = 'file';
    this.input.hidden = true;
    this.input.className = 'storage-file-input';
    this.input.setAttribute('aria-hidden', 'true');

    var button = document.getElementById(this.options.browse_button);
    if (!button) return;

    button.parentNode.appendChild(this.input);
    button.addEventListener('click', function(event) {
        event.preventDefault();
        this.input.click();
    }.bind(this));
    this.input.addEventListener('change', function() {
        this.file = this.input.files[0];
        if (this.file && this.options.init && this.options.init.FilesAdded) {
            this.options.init.FilesAdded(this, [this.file]);
        }
        if (this.file && this.options.auto_start) this.start();
    }.bind(this));
}

StorageUploader.prototype.getOption = function(name) {
    return this.options[name];
};

StorageUploader.prototype.refresh = function() {};

StorageUploader.prototype.start = async function() {
    if (!this.file) return;

    var callbacks = this.options.init || {};
    try {
        if (callbacks.BeforeUpload) callbacks.BeforeUpload(this, this.file);

        var csrfToken = document.querySelector('meta[name="csrf-token"]');
        var response = await fetch('/direct_uploads/presign', {
            method: 'POST',
            credentials: 'same-origin',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': csrfToken ? csrfToken.content : ''
            },
            body: JSON.stringify({
                filename: this.file.name,
                content_type: this.file.type || 'application/octet-stream',
                size: this.file.size
            })
        });
        var upload = await response.json();
        if (!response.ok) throw new Error(upload.error || 'Unable to prepare upload');

        var uploadHeaders = Object.assign({}, upload.headers);
        var isLocalUpload = upload.upload_url.indexOf('/') === 0;
        if (isLocalUpload) uploadHeaders['X-CSRF-Token'] = csrfToken ? csrfToken.content : '';

        var uploadResponse = await fetch(upload.upload_url, {
            method: 'PUT',
            credentials: isLocalUpload ? 'same-origin' : 'omit',
            headers: uploadHeaders,
            body: this.file
        });
        if (!uploadResponse.ok) throw new Error('File upload failed');

        if (callbacks.FileUploaded) {
            callbacks.FileUploaded(this, this.file, { response: JSON.stringify({ key: upload.key }) });
        }
        if (callbacks.UploadComplete) callbacks.UploadComplete(this, [this.file]);
    } catch (error) {
        hideSpinner();
        if (callbacks.Error) {
            callbacks.Error(this, error, error.message);
        } else {
            alert(error.message);
        }
    }
};


function alert_modal(message){
    // modal提示消息处理
}
