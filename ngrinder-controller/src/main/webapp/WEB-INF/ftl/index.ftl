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
			.title {
				color: white;
				font-size: 20px;
				font-weight: bold
			}
			.quickStart {
				padding-left: 20px;
				padding-top: 30px
			}
			.quickStart label {
				color: white;
				font-weight: bold;
			}
			.detail {
				padding-left: 135px;
				padding-top: 10px
			}
			.detail label {
				color: white;
				font-weight: bold;
			}
			.table {
				margin-bottom: 5px
			}
			.error {
				border-color: #B94A48;
				color: #B94A48
			}

		</style> 
		<script type="text/javascript">
				</script>
	</head>
	<body>
	<#include "common/navigator.ftl">
	<div class="container">
		<div class="hero-unit"/>	
			<form name="quickStart" id="quickStart" action="${req.getContextPath()}/perftest/quickStart" method="POST">
				<input type="hidden" id="jdbcRadio" name="testType" value="jdbc">
				<input type="hidden" name="url" id="url"/>
				<div class="quickStart form-inline" data-original-title="Input valid JDBC connetion string" data-content="Input valid host and port." data-placement="bottom" rel="popover">
					<label class="title"><@spring.message "home.quick.start"/></label>
					<label >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<!-- jdbc:cubrid:10.34.64.220:33000:db0001:::?charSet=utf8 -->
					<label>jdbc:cubrid:</label>
					<input type="text" id="host" name="host" class="input-small host required span2" placeholder="host">
					<label>:</label>
  					<input type="text" id="port" name="port" class="input-small port required span1" placeholder="port" value="33000">
  					<label>:</label>
  					<input type="text" id="dbname" name="dbname" class="input-small required span1" placeholder="db-name" value="demodb">
  					<label>:</label>
  					<input type="text" id="account" name="account" class="input-small required span1" placeholder="user-id" value="dba" autocomplete="off">
  					<label>:</label>
  					<input type="password" id="password" name="password" class="input-small span1" placeholder="password" autocomplete="off">
  					<label>:</label><label>?charSet=</label>
  					<input type="text" id="charset" name="charset" class="input-small required span1" placeholder="charset" value="utf-8">
  					<label >&nbsp;&nbsp;&nbsp;</label>
					<button id="startTestBtn" class="btn btn-primary" ><@spring.message "home.button.startTest"/></button>
				</div>
				<div id="detail" class="detail">
					<div class="span3 row">
						    <label class="control-label" for="version"><@spring.message "home.version"/></label>
						      	<select class="select-item span2" id="version" name="version" class="required">
									<option value ="8.4.3">8.4.3</option>
									<option value="8.4.1">8.4.1</option>
									<option value="8.4.0">8.4.0</option>
									<option value ="8.3.1">8.3.1</option>
									<option value ="8.3.0">8.3.0</option>
									<option value="8.2.2">8.2.2</option>
								</select>
						    <label class="control-label" for="testContent"><@spring.message "home.test.content"/></label>
						      	<select class="select-item span2" id="testContent" name="testContent">
									<option value ="select">Select</option>
									<option value ="insert">Insert</option>
									<option value="update">Update</option>
									<option value="delete">Delete</option>
								</select>
					</div>
					<div class="span4">
						<br>
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
			jQuery.validator.addMethod("host", function(value, element) {
			    var length = value.length;
			    var host =  /^((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]\d)|\d)(\.((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]\d)|\d)){3}$|^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$|^localhost$/
			    var result = this.optional(element) || (host.test(value));
			    if(result){
			    	$("#host").removeClass("error");
			    }else{
					$("#host").addClass("error");
			    }
			    return result;
			}, "Host string is error.");
			
			jQuery.validator.addMethod("port", function(value, element) {
			    var length = value.length;
			    var port =  /^([0-9]|[1-9]\d|[1-9]\d{2}|[1-9]\d{3}|[1-5]\d{4}|6[0-4]\d{3}|65[0-4]\d{2}|655[0-2]\d|6553[0-5])$/
			    var result = this.optional(element) || (port.test(value));
			    if(result){
			    	$("#port").removeClass("error");
			    }else{
					$("#port").addClass("error");
			    }
			    return result;
			}, "Port is error.");
			
			$("#startTestBtn").click(function() {
				if ($("#host").valid() && $("#port").valid()) {
					var urlValue = "jdbc:cubrid:" + $("#host").val() + ":" + $("#port").val() + ":" + $("#dbname").val() + ":::?charSet=" + $("#charset").val();
					$("#url").val(urlValue);
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
		   	
		    $("#host, #port").change(function() {
		    	if ($("#host").valid() && $("#port").valid()) {
		    		$("div.quickStart").popover("hide");
		    	}
		    });
	    });
	</script>
	</body>
</html>
