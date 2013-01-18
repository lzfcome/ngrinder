<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="chrome=1">
<meta http-equiv="Cache-Control" content="no-cache">
<link rel="shortcut icon" type="image/png" href="${req.getContextPath()}/img/favicon.png" />
<link href="${req.getContextPath()}/css/bootstrap.min.css" rel="stylesheet">
<link href="${req.getContextPath()}/css/ngrinder.css?${nGrinderVersion}" rel="stylesheet">
<script type="text/javascript" src="${req.getContextPath()}/js/jquery-1.7.2.min.js"></script> 
<script type="text/javascript" src="${req.getContextPath()}/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${req.getContextPath()}/js/bootbox.min.js"></script>
<script type="text/javascript" src="${req.getContextPath()}/js/utils.js?${nGrinderVersion}"></script>
<script type="text/javascript" src="${req.getContextPath()}/js/jquery.validate.min.js"></script>

<#import "spring.ftl" as spring/>
<script type="text/javascript">
	//common validation function and options. 
	$.validator.addMethod('positiveNumber',
		    function (value) { 
		        return Number(value) > 0;
		    }, '<@spring.message "common.form.validate.positiveNumber"/>');
	$.validator.addMethod('countNumber',
		    function (value) { 
		        return Number(value) >= 0;
		    }, '<@spring.message "common.form.validate.countNumber"/>');
	$.extend(jQuery.validator.messages, {
	    required: "<@spring.message "common.form.validate.empty"/>",
	    digits: "<@spring.message "common.message.validate.digits"/>",
		range: $.validator.format("<@spring.message "common.message.validate.range"/>"),
		max: $.validator.format("<@spring.message "common.message.validate.max"/>"),
		min: $.validator.format("<@spring.message "common.message.validate.min"/>"),
		maxlength: $.validator.format("<@spring.message "common.message.validate.maxlength"/>"),
		rangelength: $.validator.format("<@spring.message "common.message.validate.rangelength"/>")
	});

</script>  
<input type="hidden" id="contextPath" value="${req.getContextPath()}">

<#setting number_format="computer">
<#if currentUser?? && currentUser.timeZone??>
	<#setting time_zone="${currentUser.timeZone}"> 
</#if>  
