package org.ngrinder.home.model;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.ngrinder.common.exception.NGrinderRuntimeException;
import org.ngrinder.model.User;
import org.ngrinder.script.model.FileEntry;
import org.springframework.core.io.ClassPathResource;

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;

/**
 * Quick start entity.
 * 
 * @author Tobi
 * @since 3.0
 */
public class QuickStartEntity {

	private final static String HTTP = "http";
	private final static String JDBC = "jdbc";

	private static final Map<String, Map<String, String>> JDBC_VERSION = new HashMap<String, Map<String, String>>();
	static {
		// TODO The driver list can be obtained from an external address,
		// and available for download.
		// So that we can remove the following code.
		Map<String, String> cubrid = new HashMap<String, String>() {
			private static final long serialVersionUID = -5654695777189668583L;
			{
				this.put("9.0.0", "cubrid/JDBC-9.0.0.0478-cubrid.jar");
				this.put("8.4.3", "cubrid/JDBC-8.4.3.0150-cubrid.jar");
				this.put("8.4.1", "cubrid/JDBC-8.4.1.7007-cubrid.jar");
				this.put("8.4.0", "cubrid/JDBC-8.4.0.0241-cubrid.jar");
				this.put("8.3.1", "cubrid/JDBC-8.3.1.0173-cubrid.jar");
				this.put("8.3.0", "cubrid/JDBC-8.3.0.1004-cubrid.jar");
				this.put("8.2.2", "cubrid/JDBC-8.2.2.7001.jar");
			}

			@Override
			public String toString() {
				return "cubrid.jdbc.driver.CUBRIDDriver";
			}
		};
		Map<String, String> mysql = new HashMap<String, String>() {
			private static final long serialVersionUID = -6392212998116278199L;
			{
				this.put("5.1.22", "mysql/mysql-connector-java-5.1.22-bin.jar");
				this.put("5.1.9", "mysql/mysql-connector-java-5.1.9-bin.jar");
			}

			@Override
			public String toString() {
				return "org.gjt.mm.mysql.Driver";
			}
		};
		Map<String, String> oracle = new HashMap<String, String>() {
			private static final long serialVersionUID = 6823406305517426140L;
			{
				this.put("11g", "oracle/Oracle_11g_11.2.0.1.0_JDBC_ojdbc6.jar");
				this.put("10g", "oracle/Oracle_10g_10.2.0.4_JDBC_classes12.jar");
			}

			@Override
			public String toString() {
				return "oracle.jdbc.OracleDriver";
			}
		};
		JDBC_VERSION.put("cubrid", cubrid);
		JDBC_VERSION.put("mysql", mysql);
		JDBC_VERSION.put("oracle", oracle);
	}

	private String testType = "";
	private String url = "";
	private String version;
	private String account = "";
	private String password = "";
	private String testContent = "select";

	private ProtocolScript protocolScript;

	private interface ProtocolScript {
		FileEntry prepareScriptEntry(User user) throws Exception;

		FileEntry prepareLibEntry() throws Exception;

		String getHostString();
	}

	private class HTTPScript implements ProtocolScript {

		private URL testUrl;
		private String urlHost;
		private String urlPath;

		HTTPScript() {
			try {
				testUrl = new URL(url);
				urlHost = testUrl.getHost();
				urlPath = testUrl.getPath();
			} catch (MalformedURLException e) {
				throw new NGrinderRuntimeException("Error while translating " + url, e);
			}
		}

		@Override
		public FileEntry prepareScriptEntry(User user) throws Exception {
			FileEntry fileEntry = new FileEntry();
			String filePath = getScriptPath();
			fileEntry.setPath(filePath);
			fileEntry.setContent(loadHTTPTemplate(user));
			addHostProperties(fileEntry);
			fileEntry.setDescription("Quick test (HTTP) for " + url);
			return fileEntry;
		}

		private String loadHTTPTemplate(User user) throws Exception {
			Configuration freemarkerConfig = new Configuration();
			ClassPathResource cpr = new ClassPathResource("script_template");
			freemarkerConfig.setDirectoryForTemplateLoading(cpr.getFile());
			freemarkerConfig.setObjectWrapper(new DefaultObjectWrapper());
			Template template = freemarkerConfig.getTemplate("basic_template.ftl");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("url", url);
			map.put("user", user);
			StringWriter writer = new StringWriter();
			template.process(map, writer);
			String content = writer.toString();
			writer.close();
			return content;
		}

		private String getScriptPath() {
			String filePath = "";
			urlPath = "/".equals(urlPath) ? "" : urlPath;
			filePath = (urlHost + urlPath).replaceAll("[\\&\\?\\%\\-]", "_");
			if (!StringUtils.isBlank(filePath)) {
				filePath += "/" + "script.py";
			} else {
				filePath = "script.py";
			}
			return filePath;
		}

		private void addHostProperties(FileEntry fileEntry) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("targetHosts", StringUtils.trim(urlHost));
			fileEntry.setProperties(map);
		}

		@Override
		public String getHostString() {
			return urlHost;
		}

		@Override
		public FileEntry prepareLibEntry() throws Exception {
			return null;
		}
	}

	private class JDBCScript implements ProtocolScript {
		private String dbType;
		private String driver;
		private String driverClass;
		private String driverPath;
		private String urlHost;

		JDBCScript() {
			// cubrid--->jdbc:cubrid:10.34.64.220:33000/db0001:::?charSet=utf8
			urlHost = url.replaceAll("(^jdbc:[\\w\\d\\-]+:((thin:@)|(Tds:)|(sqlserver:))?(//)?)|(:\\d+.+$)", "");
			dbType = url.replaceAll("(^jdbc:)|(:.+$)", "");
			driver = JDBC_VERSION.get(dbType).toString();
			if (StringUtils.isBlank(driver)) {
				throw new RuntimeException("The type of DB is not supported.");
			}
			int tmp = driver.lastIndexOf(".");
			driverPath = driver.substring(0, tmp);
			driverClass = driver.substring(tmp + 1);

		}

		@Override
		public FileEntry prepareScriptEntry(User user) throws Exception {
			FileEntry fileEntry = new FileEntry();
			String filePath = getScriptPath();
			fileEntry.setPath(filePath);
			fileEntry.setContent(loadJDBCTemplate(user));
			addHostProperties(fileEntry);
			fileEntry.setDescription("Quick test (JDBC) for " + url);
			return fileEntry;
		}

		private String loadJDBCTemplate(User user) throws Exception {
			Configuration freemarkerConfig = new Configuration();
			ClassPathResource cpr = new ClassPathResource("script_template");
			freemarkerConfig.setDirectoryForTemplateLoading(cpr.getFile());
			freemarkerConfig.setObjectWrapper(new DefaultObjectWrapper());
			Template template = freemarkerConfig.getTemplate("jdbc_" + testContent + "_template.ftl");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("url", url);
			map.put("account", account);
			map.put("password", password);
			map.put("driverPath", driverPath);
			map.put("jdbcDriver", driverClass);
			map.put("user", user);
			StringWriter writer = new StringWriter();
			template.process(map, writer);
			String content = writer.toString();
			writer.close();
			return content;
		}

		private String getScriptPath() {
			String filePath = getPath();
			if (!StringUtils.isBlank(filePath)) {
				filePath += "/" + testContent + ".py";
			} else {
				filePath = testContent + ".py";
			}
			return filePath;
		}

		private String getLibPath() {
			String filePath = getPath();
			if (!StringUtils.isBlank(filePath)) {
				filePath += "/" + "lib";
			} else {
				filePath = "lib";
			}
			return filePath;
		}

		private String getPath() {
			String filePath = "";
			filePath = (urlHost).replaceAll("[\\&\\?\\%\\-]", "_");
			return filePath;
		}

		private void addHostProperties(FileEntry fileEntry) {
			Map<String, String> map = new HashMap<String, String>();
			map.put("targetHosts", StringUtils.trim(urlHost));
			fileEntry.setProperties(map);
		}

		@Override
		public String getHostString() {
			return urlHost;
		}

		@Override
		public FileEntry prepareLibEntry() throws Exception {
			ClassPathResource cpr = new ClassPathResource("driver_libraries");
			File driver = new File(cpr.getFile(), JDBC_VERSION.get(dbType).get(version));
			InputStream is = null;
			ByteArrayOutputStream out = new ByteArrayOutputStream();

			try {
				is = new FileInputStream(driver);
				byte[] b = new byte[4096];
				int n;
				while ((n = is.read(b)) != -1) {
					out.write(b, 0, n);
				}
			} finally {
				IOUtils.closeQuietly(is);
			}

			FileEntry fileEntry = new FileEntry();
			fileEntry.setContentBytes(out.toByteArray());
			fileEntry.setDescription("JDBC driver library.");
			fileEntry.setPath(FilenameUtils.separatorsToUnix(FilenameUtils.concat(getLibPath(), driver.getName())));
			return fileEntry;
		}
	}

	public String getTestType() {
		return testType;
	}

	public void setTestType(String testType) {
		this.testType = testType;
		init();
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
		init();
	}

	private void init() {
		if (StringUtils.isBlank(this.testType)) {
			return;
		}
		if (StringUtils.equalsIgnoreCase(testType, HTTP)) {
			if (StringUtils.isBlank(this.url)) {
				return;
			}
			protocolScript = new HTTPScript();
		} else if (StringUtils.equalsIgnoreCase(testType, JDBC)) {
			if (StringUtils.isBlank(this.url) || StringUtils.isBlank(this.account)
					|| StringUtils.isBlank(this.password) || StringUtils.isBlank(this.password)) {
				return;
			}
			protocolScript = new JDBCScript();
		}
	}

	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
		init();
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
		init();
	}

	public String getTestContent() {
		return testContent;
	}

	public void setTestContent(String testContent) {
		this.testContent = testContent;
		init();
	}

	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}

	public FileEntry prepareScriptEntry(User user) throws Exception {
		return protocolScript.prepareScriptEntry(user);
	}

	public FileEntry prepareLibEntry() throws Exception {
		return protocolScript.prepareLibEntry();
	}

	public String getHostString() {
		return protocolScript.getHostString();
	}

}
