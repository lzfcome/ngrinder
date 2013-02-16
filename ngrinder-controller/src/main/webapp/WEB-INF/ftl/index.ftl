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
				padding-top: 35px
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
				<input type="hidden" id="jdbcRadio" name="testType" value="jdbc"/>
				<div class="quickStart" data-original-title="<@spring.message "home.tip.url.title"/>" data-content="<@spring.message "home.tip.url.jdbc.content"/>" data-placement="bottom" rel="popover">
					<label class="title"><@spring.message "home.quick.start"/></label>
					<label >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<input type="text" name="url" id="url" class="span7 jdbc required" placeholder="<@spring.message "home.placeholder.jdbc.url"/>"/> 
					<button id="startTestBtn" class="btn btn-primary" ><@spring.message "home.button.startTest"/></button>
				</div>
				<div id="detail" class="detail">
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
								<input type="text" name="account" id="account" class="span2 required" style="height:14px" value="dba" autocomplete="off"/> <br>
								<input type="text" name="password" id="Password" class="span2" style="height:14px" autocomplete="off"/> <br>
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
			initDriver();
			jQuery.validator.addMethod("jdbc", function(value, element) {
			    var length = value.length;
			    var jdbc =  /(^jdbc:\w+:).+[\.\w\d]+(:\d+)?.+$/
			    return this.optional(element) || (jdbc.test(value));
			}, "JDBC connection string is error.");
			
			$("#startTestBtn").click(function() {
				if ($("#url").valid()) {
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
		    	if ($("#url").valid()) {
					initDriver();
				}
		    });
	    });
		
	    var driver = [];
	    driver["cubrid"] = ["9.0.0", "8.4.3", "8.4.1", "8.4.0", "8.3.1", "8.3.0", "8.2.2"];
	    driver["mysql"] = ["5.1.22", "5.1.9"];
	    // driver["oracle"] = ["11g", "10g"];
	    driver["postgresql"] = ["9.2", "9.1", "9.0"];
	    function initDriver(){
	    	var url = $("#url").val();
		    var db = url.replace(/(^jdbc:)|(:.+$)/g, "");
		    $("#version").empty();
		    $("#version").append(getDirver(db));
	    }
	    function getDirver(db) {
	    	if(!db){
	    		return;
	    	}
			var contents = [];
			if(!driver[db]){
				alert("Do not support the database type: " + db+".\nSupported database types: CUBRID, MySQL, PostgreSQL.");
				return;
			}
			var ver;
			for(ver in driver[db]){
				contents.push("<option value='" + driver[db][ver] + "'>" + driver[db][ver] + "</option>");
			}
			return contents.join("\n");
		}
	    
	</script>
	</body>
</html>
