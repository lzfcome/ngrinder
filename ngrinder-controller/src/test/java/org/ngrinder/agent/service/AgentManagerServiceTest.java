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
package org.ngrinder.agent.service;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;

import java.util.List;
import java.util.Map;

import junit.framework.Assert;
import net.grinder.message.console.AgentControllerState;

import org.apache.commons.lang.mutable.MutableInt;
import org.junit.Test;
import org.ngrinder.AbstractNGrinderTransactionalTest;
import org.ngrinder.agent.model.AgentInfo;
import org.ngrinder.agent.repository.AgentManagerRepository;
import org.ngrinder.infra.config.Config;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Agent service test.
 * 
 * @author Tobi
 * @since 3.0
 */
public class AgentManagerServiceTest extends AbstractNGrinderTransactionalTest {

	@Autowired
	private AgentManagerService agentManagerService;

	@Autowired
	private AgentManagerRepository agentRepository;

	@Autowired
	private Config config;


	@Test
	public void testSaveGetDeleteAgent() {
		AgentInfo agent = saveAgent("save");
		AgentInfo agent2 = agentManagerService.getAgent(agent.getId(), false);
		Assert.assertNotNull(agent2);

		List<AgentInfo> agentListDB = agentManagerService.getLocalAgentListFromDB();
		agentListDB = agentManagerService.getLocalAgentListFromDB();
		Assert.assertNotNull(agentListDB);

		agentManagerService.approve(agent.getId(), true);

		agentManagerService.deleteAgent(agent.getId());
		agent2 = agentManagerService.getAgent(agent.getId(), false);
		Assert.assertNull(agent2);
	}

	private AgentInfo saveAgent(String key) {
		AgentInfo agent = new AgentInfo();
		agent.setIp("1.1.1.1");
		agent.setName("testAppName" + key);
		agent.setPort(8080);
		agent.setRegion("testRegion" + key);
		agent.setStatus(AgentControllerState.BUSY);
		agentManagerService.saveAgent(agent);
		return agent;
	}

	@Test
	public void testGetUserAvailableAgentCount() {
		Map<String, MutableInt> countMap = agentManagerService.getUserAvailableAgentCountMap(getTestUser());
		String currRegion = config.getRegion();
		int oriCount = countMap.get(currRegion).intValue();

		AgentInfo agentInfo = new AgentInfo();
		agentInfo.setName("localhost");
		agentInfo.setRegion(config.getRegion());
		agentInfo.setIp("127.127.127.127");
		agentInfo.setPort(1);
		agentInfo.setStatus(AgentControllerState.READY);
		agentInfo.setApproved(true);
		agentManagerService.saveAgent(agentInfo);
		countMap = agentManagerService.getUserAvailableAgentCountMap(getTestUser());

		int newCount = countMap.get(config.getRegion()).intValue();
		assertThat(newCount, is(oriCount + 1));
	}

	@Test
	public void testCheckAgentStatus() {
		AgentInfo agentInfo = new AgentInfo();
		agentInfo.setName("localhost");
		agentInfo.setRegion(config.getRegion());
		agentInfo.setIp("127.127.127.127");
		agentInfo.setPort(1);
		agentInfo.setStatus(AgentControllerState.READY);
		agentManagerService.saveAgent(agentInfo);
		agentManagerService.checkAgentStatusRegularly();

		AgentInfo agentInDB = agentRepository.findOne(agentInfo.getId());
		assertThat(agentInDB.getIp(), is(agentInfo.getIp()));
		assertThat(agentInDB.getName(), is(agentInfo.getName()));
		assertThat(agentInDB.getStatus(), is(AgentControllerState.INACTIVE));
	}
	
	@Test
	public void testOther() {
		agentManagerService.getLocalAgents();
		agentManagerService.getLocalAgentIdentityByIpAndName("127.0.0.1", "127.0.0.1");
		agentManagerService.stopAgent(0L);
		agentManagerService.requestShareAgentSystemDataModel(0L);
		agentManagerService.getAgentSystemDataModel("127.0.0.1", "127.0.0.1");
		agentManagerService.setAgentManager(agentManagerService.getAgentManager());
		agentManagerService.setAgentRepository(agentManagerService.getAgentRepository());
	}

}
