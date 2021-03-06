/* 
 * Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. 
 */
package org.ngrinder.monitor.share.domain;

import java.io.Serializable;
import java.util.Date;

import javax.management.openmbean.CompositeData;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.ngrinder.common.util.DateUtil;

/**
 * 
 * System info object to save date collected bu monitor.
 * 
 * @author Mavlarn
 * @since 2.0
 */
public class SystemInfo extends MonitorInfo implements Serializable {

	private static final long serialVersionUID = -2995334644975166549L;

	public static final String HEADER = "ip,system,collectTime,freeMemory,totalMemory,cpuUsedPercentage";

	/**
	 * Enum for the system type, linux or windows.
	 */
	public enum System {
		LINUX, WINDOW
	}

	private System system;

	private long totalCpuValue;

	private long idleCpuValue;

	private double[] loadAvgs = new double[3];

	private long freeMemory;

	private long totalMemory;

	private float cpuUsedPercentage;

	private String ip;

	@Override
	public void parse(CompositeData cd) {
		if (cd == null) {
			return;
		}
		setCollectTime(getLong(cd, "collectTime"));
		this.system = System.valueOf(getString(cd, "system"));
		this.totalCpuValue = getLong(cd, "totalCpuValue");
		this.idleCpuValue = getLong(cd, "idlecpu");
		this.freeMemory = getLong(cd, "freeMemory");
		this.totalMemory = getLong(cd, "totalMemory");
		this.cpuUsedPercentage = getFloat(cd, "CPUUsedPercentage");
		this.setLoadAvgs((double[]) cd.get("loadAvgs"));

	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public System getSystem() {
		return system;
	}

	public void setSystem(System system) {
		this.system = system;
	}

	public void setSystem(String system) {
		this.system = System.valueOf(system);
	}

	public void setCPUUsedPercentage(float cpuUsedPercentage) {
		this.cpuUsedPercentage = cpuUsedPercentage;
	}

	public float getCPUUsedPercentage() {
		return cpuUsedPercentage;
	}

	public long getIdlecpu() {
		return idleCpuValue;
	}

	public long getTotalCpuValue() {
		return totalCpuValue;
	}

	public void setLoadAvgs(double[] loadAvgs) {
		this.loadAvgs = loadAvgs;
	}

	public double[] getLoadAvgs() {
		return loadAvgs;
	}

	public long getFreeMemory() {
		return freeMemory;
	}

	public void setTotalCpuValue(long totalCpuValue) {
		this.totalCpuValue = totalCpuValue;
	}

	public void setIdleCpuValue(long idleCpuValue) {
		this.idleCpuValue = idleCpuValue;
	}

	public void setFreeMemory(long freeMemory) {
		this.freeMemory = freeMemory;
	}

	public long getTotalMemory() {
		return totalMemory;
	}

	public void setTotalMemory(long totalMemory) {
		this.totalMemory = totalMemory;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}

	/**
	 * Get record string.
	 * 
	 * @return record string
	 */
	public String getRecordString() {
		StringBuilder sb = new StringBuilder();
		sb.append(ip).append(",").append(system).append(",");
		sb.append(DateUtil.getCollectTimeInLong(new Date(getCollectTime()))).append(",").append(freeMemory).append(",");
		sb.append(totalMemory).append(",").append(cpuUsedPercentage);
		return sb.toString();

	}
}
