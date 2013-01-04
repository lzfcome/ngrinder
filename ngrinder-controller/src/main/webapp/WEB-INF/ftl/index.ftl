<!DOCTYPE html>
<html>
	<head>
		<#include "common/common.ftl">
		<title><@spring.message "home.title"/></title>
		<style>
			.hero-unit { 
				background-image: url('${req.getContextPath()}/img/bg_main_banner_<@spring.message "common.language"/>.png');
				margin-bottom: 10px;
				height: 200px;
				padding: 0
			}    
			.testType {
				padding-left: 20px;
				padding-top: 20px;
				font-size: 12px;
				font-weight: bold
			}
			.testType label {
				color: white;
				font-weight: bold
			}
			.title {
				color: white;
				font-size: 20px;
				font-weight: bold
			}
			.quickStart {
				padding-left: 20px;
				padding-top: 5px
			}
			.description {
				padding-left: 160px;
				padding-top: 5px
			}
			.description label {
				color: white
			}
			.detail {
				padding-left: 140px;
				padding-top: 10px
			}
			.detail label {
				color: white
			}
			.table {
				margin-bottom: 5px
			} 
		</style> 
		<script type="text/javascript">
				</script>
	</head>
	<body>
	<#include "common/navigator.ftl">
	<div class="container">
		<div class="hero-unit"/>	
			<form class="form-inline" name="quickStart" id="quickStart" action="${req.getContextPath()}/perftest/quickStart" method="POST">
				<div class="testType">
					<label class="title"><@spring.message "home.test.type"/></label>
					<label >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<label >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<label > <input type="radio" id="httpRadio" name="testType" checked value="http"> HTTP/HTTPS</label>
					<label >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<label > <input type="radio" id="jdbcRadio" name="testType" value="jdbc"> JDBC</label>
				</div>
				<div class="quickStart" data-original-title="<@spring.message "home.tip.url.title"/>" data-content="<@spring.message "home.tip.url.content"/>" data-placement="bottom" rel="popover">
					<label class="title"><@spring.message "home.quick.start"/></label>
					<label >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<input type="text" name="url" id="url" class="span7 url required" placeholder="<@spring.message "home.placeholder.url"/>"/> 
					<button id="startTestBtn" class="btn btn-primary" ><@spring.message "home.button.startTest"/></button>
				</div>
				<div id="description" class="description" style="display:none">
					<label><@spring.message "home.descript1"/></label><br>
					<table width=400 style="border-top:1px solid white" cellspacing=0 cellpadding=2><tr><td></td></tr></table>
					<label><@spring.message "home.descript2"/></label><br>
					<label><@spring.message "home.descript3"/></label><br>
					<label><@spring.message "home.descript4"/></label>
				</div>
				<div id="detail" class="detail" style="display:none">
					<div class="span3">
						<div class="row">
							<div class="span1">
								<label><@spring.message "home.version"/></label><br>
								<label><@spring.message "home.account"/></label><br>
								<label><@spring.message "home.password"/></label><br>
							</div>
							<div class="span2">
								<select class="select-item" id="version" name="version" style="width:140px" class="required">
								</select><br>
								<input type="text" name="account" id="account" class="span2 required" style="height:14px"/> <br>
								<input type="text" name="password" id="Password" class="span2 required" style="height:14px"/> <br>
							</div>
						</div>
					</div>
					<div class="span4">
						<label><@spring.message "home.test.content"/></label>
						<select class="select-item" id="testContent" name="testContent">
							<option value ="select">Select</option>
							<option value ="insert">Insert</option>
							<option value="update">Update</option>
							<option value="delete">Delete</option>
						</select><br>
						<label><@spring.message "home.test.data1"/></label><br>
						<label><@spring.message "home.test.data2"/></label><br>
					</div>
				</div>
			</form>
		</div>
		<div class="row">
			<div class="span6">
				<div class="page-header">
	 				 <h3><@spring.message "home.qa.title"/></h3>  
				</div>
				<div class="alert alert-info">
			  	<@spring.message "home.qa.message"/>
			  	</div> 
		   		<div class="well">
			  		<br/>
				  	<#if right_panel_entries?has_content>
					  	<table class="table table-striped">
					  		<#list right_panel_entries as each_right_entry>
					  			<tr>
					  				<td>
					  					<#if each_right_entry.isNew()><span class="label label-info">new</span></#if>
					  					<a href="${each_right_entry.link }" target="_blank">${each_right_entry.title}
					  					</a> 
					  				</td>
					  				<td>${each_right_entry.lastUpdatedDate?string("yyyy-MM-dd")} 
					  				</td>
					  			</tr>
					  		</#list>
				  			<tr>
				  				<td>
				  					<img src="${req.getContextPath()}/img/asksupport.gif"/> 
				  					<a href="http://github.com/nhnopensource/ngrinder/issues/new?labels=question">
				  						<@spring.message "home.button.ask"/>
				  					</a>&nbsp;&nbsp;&nbsp; 
				  					<img src="${req.getContextPath()}/img/bug_icon.gif"/>
				  					<a href="http://github.com/nhnopensource/ngrinder/issues/new?labels=bug">
				  						<@spring.message "home.button.bug"/>
				  					</a>	
				  				</td>
				  				<td><a href="http://github.com/nhnopensource/ngrinder/issues" target="_blank"><i class="icon-share-alt"></i>&nbsp;<@spring.message "home.button.more"/></a></td>
				  			</tr>
				  			</div>
		  				</table>
		   		 	 </#if> 	
  			    </div>
			</div>
			<div class="span6">
				<div class="page-header">
	 				 <h3><@spring.message "home.developerResources.title"/></h3> 
				</div> 
				<div class="alert alert-info">
			  		<@spring.message "home.developerResources.message"/> 
			  	</div> 
		   		<div class="well">
			  		<br/>
				  	<#if left_panel_entries?has_content>
					  	<table class="table table-striped">
					  		<#list left_panel_entries as each_left_entry>
					  			<tr>
					  				<td> 
					  					<#if each_left_entry.isNew()><span class="label label-info">new</span></#if>
					  					<a href="${each_left_entry.link }" target="_blank">${each_left_entry.title}</a>
					  				</td>
					  				<td>${each_left_entry.lastUpdatedDate?string("yyyy-MM-dd")}</td>
					  			</tr>
					  		</#list>
				  			<tr>
				  				<td></td>
				  				<td><a href="http://www.cubrid.org/wiki_ngrinder" target="_blank"><i class="icon-share-alt"></i>&nbsp;<@spring.message "home.button.more"/></a></td>
				  			</tr>
				  			</div>
		  				</table>
		   		 	 </#if> 
			  	</div>
			</div>
		</div>
		<#include "common/copyright.ftl">
	</div>
	<script>
		$(document).ready(function(){
			initTestType();
			initDriver();
			jQuery.validator.addMethod("jdbc", function(value, element) {
			    var length = value.length;
			    var jdbc =  /(^jdbc:(cubrid)|(mysql)|(oracle):).+[\.\w\d]+:\d+.+$/
			    return this.optional(element) || (jdbc.test(value));
			}, "JDBC connection string is error.");
			
			$.validator.addMethod('url_ex',
				    function (value) { 
				        return /^((https?|ftp):\/\/)?(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(value);
			}, '');
			
			
			$("#startTestBtn").click(function() {
				if ($("#url").valid()) {
					var urlValue = $("#url").val();
					if (!urlValue.match("^(http|ftp|jdbc)")) {
						$("#url").val("http://" + urlValue);
					}
					$("#quickStart").submit();
					return true;
				}
				return false;
			})
			
	        $("#quickStart").validate({
	            errorPlacement: function(error, element) {
	            	$("div.quickStart").popover("show");
		        }
		    });
		   	
		    $("#url").change(function() {
		    	if ($(this).valid()) {
		    		$("div.quickStart").popover("hide");
		    	}
		    });
		    
		    $("#url").blur(function() {
		    	initDriver();
		    });
		    
		    $("#httpRadio, #jdbcRadio").change(function() {
				changeEvent();
			});
	    });
		
	    var driver = [];
	    driver["cubrid"] = ["9.0.0", "8.4.3", "8.4.1", "8.4.0", "8.3.1", "8.3.0", "8.2.2"];
	    driver["mysql"] = ["5.1.22", "5.1.9"];
	    driver["oracle"] = ["11g", "10g"];
	    function initDriver(){
	    	var url = $("#url").val();
		    var db = url.replace(/(^jdbc:)|(:.+$)/g, "");
		    $("#version").empty();
		    $("#version").append(getDirver(db));
	    }
	    function getDirver(db) {
			var contents = [];
			if(!driver[db]){
				//alert("Do not support the database type: " + db);
				return;
			}
			var ver;
			for(ver in driver[db]){
				contents.push("<option value='" + driver[db][ver] + "'>" + driver[db][ver] + "</option>");
			}
			return contents.join("\n");
		}
	    
	    function changeEvent() {
	    	initTestType();
	    }
	    
	    function initTestType() {
	    	if ($("#httpRadio").attr("checked") == "checked") {
				$("#detail").hide();
				$("#description").show();
				//$("#description").toggle(500);
				
				$("#url").addClass("url");
				$("#url").removeClass("jdbc");
				
				$("div.quickStart").attr("data-content","<@spring.message "home.tip.url.content"/>");
			}else if ($("#jdbcRadio").attr("checked") == "checked") {
				$("#description").hide();
				$("#detail").show();
				//$("#detail").toggle(500);
				
				$("#url").addClass("jdbc");
				$("#url").removeClass("url"); 
				
				$("div.quickStart").attr("data-content","<@spring.message "home.tip.url.jdbc.content"/>");
			}
	    }
	</script>
	</body>
</html>
