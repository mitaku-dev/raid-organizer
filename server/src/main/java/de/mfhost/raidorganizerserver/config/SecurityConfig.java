package de.mfhost.raidorganizerserver.config;

import de.mfhost.raidorganizerserver.security.JwtTokenFilter;
import de.mfhost.raidorganizerserver.security.oauth2.CustomOAuth2User;
import de.mfhost.raidorganizerserver.security.oauth2.OAuth2LoginSucessHandeler;
import de.mfhost.raidorganizerserver.security.oauth2.OAuth2UserService;
import de.mfhost.raidorganizerserver.user.UserRepository;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.InMemoryOAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import javax.servlet.http.HttpServletResponse;

import static java.lang.String.format;

@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    private final UserRepository userRepo;
    private final JwtTokenFilter jwtTokenFilter;

    private final OAuth2UserService oAuth2UserService;
    private final OAuth2LoginSucessHandeler loginSucessHandeler;


    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(username -> userRepo
                .findByUsername(username)
                .orElseThrow(
                        () -> new UsernameNotFoundException(
                                format("User: %s not found", username)
                        )
                )
        );
    }
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.cors().and().csrf().disable();


        http = http.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).and();



        http = http.exceptionHandling().authenticationEntryPoint(
                (request, response, authException) -> {
                    response.sendError(
                            HttpServletResponse.SC_UNAUTHORIZED,
                            authException.getMessage()
                    );
                }
        ).and();



        http.authorizeRequests()
                .antMatchers("/oauth2/**").permitAll()
                .antMatchers("/login/**").permitAll()
                .antMatchers("/api/public/**").permitAll()
                .antMatchers("/auth/**").permitAll()
                .anyRequest().authenticated()
        .and()
        .oauth2Login()
                .userInfoEndpoint()
                .userService(oAuth2UserService)
                .and()
                .successHandler(loginSucessHandeler)
                .failureHandler(failureHandler());

        http.addFilterBefore(jwtTokenFilter, UsernamePasswordAuthenticationFilter.class);


    }

    @Bean
    SimpleUrlAuthenticationFailureHandler failureHandler() {
        return new SimpleUrlAuthenticationFailureHandler();
    }

    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source =
                new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.addAllowedOrigin("*");
        config.addAllowedHeader("*");
        config.addAllowedMethod("*");
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }

    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }


    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }

}