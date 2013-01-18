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
package org.ngrinder.user.service;

import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.nullValue;
import static org.junit.Assert.assertThat;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.ngrinder.AbstractNGrinderTransactionalTest;
import org.ngrinder.infra.config.Config;
import org.ngrinder.model.PerfTest;
import org.ngrinder.model.Permission;
import org.ngrinder.model.Role;
import org.ngrinder.model.User;
import org.ngrinder.perftest.service.PerfTestService;
import org.springframework.beans.factory.annotation.Autowired;

public class UserServiceTest extends AbstractNGrinderTransactionalTest {

	@Autowired
	private UserService userService;

	@Before
	public void before() {

	}

	private User createTestUser(String userId) {
		User user = new User();
		user.setUserId(userId);
		user.setUserName("hello");
		user.setPassword("www");
		user.setEmail("www@test.com");
		user.setRole(Role.SUPER_USER);
		user = userService.saveUser(user);
		assertThat(user.getRole().hasPermission(Permission.GET_ALL_TESTS),is(true));
		assertThat(user.getRole().hasPermission(Permission.CHECK_SCRIPT_OFOTHER),is(true));
		assertThat(user.getRole().hasPermission(Permission.VALIDATE_SCRIPT_OFOTHER),is(true));
		assertThat(user.getRole().hasPermission(Permission.SWITCH_TO_ANYONE),is(true));
		assertThat(user.getUserId(), is(userId));
		return user;
	}

	@Test
	public void testUpdateUser() {
		User user = createTestUser("testId1");

		User user2 = new User();
		user2.setId(user.getId());
		user2.setUserId("hello");
		user2.setPassword("www222");
		user2.setEmail("www@test.com");
		user2.setRole(Role.USER);
		userService.modifyUser(user2, null);
		User userById = userService.getUserById("hello");
		assertThat(userById.getId(), is(user.getId()));

		userService.saveUser(user2, Role.ADMIN);
		userById = userService.getUserById("hello");
		assertThat(userById.getRole().hasPermission(Permission.GET_ALL_TESTS),is(true));
		assertThat(userById.getRole().hasPermission(Permission.CHECK_SCRIPT_OFOTHER),is(true));
		assertThat(userById.getRole().hasPermission(Permission.VALIDATE_SCRIPT_OFOTHER),is(true));
		assertThat(userById.getRole().hasPermission(Permission.SWITCH_TO_ANYONE),is(true));
		assertThat(userById.getRole(), is(Role.ADMIN));
	}

	@Test
	public void testDeleteUsers() {
		final User user = createTestUser("testId1");
		List<String> userIds = new ArrayList<String>();
		userIds.add(user.getUserId());
		userService.deleteUsers(userIds);
		User userById = userService.getUserById(user.getUserId());
		Assert.assertNull(userById);
	}

	@Test
	public void testGetRole() {
		Role role = userService.getRole("Administrator");
		assertThat(role, is(Role.ADMIN));

		role = userService.getRole("General User");
		assertThat(role, is(Role.USER));

		role = userService.getRole("Super User");
		assertThat(role, is(Role.SUPER_USER));

		role = userService.getRole("System User");
		assertThat(role, is(Role.SYSTEM_USER));

		role = userService.getRole("Test");
		Assert.assertNull(role);
	}

	@Autowired
	PerfTestService perfTestService;

	@Autowired
	Config config;

	@SuppressWarnings("serial")
	@Test
	public void testUserDelete() {
		final User user = getTestUser();
		File scriptDirectory = config.getHome().getScriptDirectory(user);
		scriptDirectory.mkdirs();
		PerfTest perfTest = new PerfTest();
		perfTest.setTestName("Hello");
		perfTest.setTagString("Hello,World");
		perfTest = perfTestService.savePerfTest(user, perfTest);
		userService.deleteUsers(new ArrayList<String>() {
			{
				add(user.getUserId());
			}
		});
		assertThat(perfTestService.getPerfTest(perfTest.getId()), nullValue());
		assertThat(scriptDirectory.exists(), is(false));
	}
	
	@Test
	public void testGetUserListByKeyWord() {
		User user = new User();
		user.setUserId("testIdForNameSearch");
		user.setUserName("testIdForNameSearch");
		user.setPassword("111111");
		user.setEmail("testIdForNameSearch@test.com");
		user.setRole(Role.USER);
		user = userService.saveUser(user);
		assertThat(user.getUserId(), is("testIdForNameSearch"));
		
		List<User> userList = userService.getUserListByKeyWord("ForNameSearch");
		assertThat(userList.size(), is(1));

		userList = userService.getUserListByKeyWord("ForName");
		assertThat(userList.size(), is(1));
	}
}
