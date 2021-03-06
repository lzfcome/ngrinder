/*
 * Copyright (C) 2012 - 2012 NHN Corporation
 * All rights reserved.
 *
 * This file is part of The nGrinder software distribution. Refer to
 * the file LICENSE which is part of The nGrinder distribution for
 * licensing details. The nGrinder distribution is available on the
 * Internet at http://nhnopensource.org/ngrinder
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package org.ngrinder.security;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.ngrinder.AbstractNGrinderTransactionalTest;
import org.ngrinder.model.Role;
import org.ngrinder.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.authentication.encoding.PlaintextPasswordEncoder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.StandardPasswordEncoder;

/**
 * Class description.
 * 
 * @author Mavlarn
 * @since
 */
public class NGrinderAuthenticationProviderTest extends AbstractNGrinderTransactionalTest {

	@Autowired
	private NGrinderAuthenticationProvider provider;
	
	@Autowired
	private NGrinderUserDetailsService userDetailService;

	@Autowired
	@Qualifier("shaPasswordEncoder")
	private PasswordEncoder passwordEncoder;
	
	@Test
	public void testAdditionalAuthenticationChecks() {
		UserDetails user = userDetailService.loadUserByUsername(getTestUser().getUserId());
		
		//remove authentication temporally
		Authentication oriAuth = SecurityContextHolder.getContext().getAuthentication();
		SecurityContextImpl context = new SecurityContextImpl();
		SecurityContextHolder.setContext(context);

		UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken("admin", null);
		try {
			provider.additionalAuthenticationChecks(user, token);
			assertTrue(false);
		} catch (BadCredentialsException e) {
			assertTrue(true);
		}

		token = new UsernamePasswordAuthenticationToken("TEST_USER", "123");
		provider.additionalAuthenticationChecks(user, token);
		
		context.setAuthentication(oriAuth);
	}
	
	@Test
	public void testSetPasswordEncoder() {
		org.springframework.security.authentication.encoding.PasswordEncoder enc1 = new PlaintextPasswordEncoder();
		provider.setPasswordEncoder(enc1);

		org.springframework.security.crypto.password.PasswordEncoder enc2 = new StandardPasswordEncoder();
		provider.setPasswordEncoder(enc2);
		
		provider.setPasswordEncoder(passwordEncoder);
	}
	
	@Test
	public void testAddNewUserIntoLocal() {
		SecuredUser secUser = new SecuredUser(getTestUser(), null);
		provider.addNewUserIntoLocal(secUser);
		assertThat(secUser.getUser(), is(getTestUser()));
		
		User tmpUser = new User("tmpUserId", "tmpName", "123", "test.nhn.com", Role.USER);
		SecuredUser tmpSecUser = new SecuredUser(tmpUser, null);
		provider.addNewUserIntoLocal(tmpSecUser);
		assertThat(tmpSecUser.getUser(), is(tmpUser));
	}
}
