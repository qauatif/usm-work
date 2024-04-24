package com.usm.work.project;

import java.time.LocalDateTime;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("api/v1/project")
public class ProjectController {

	@GetMapping
	public String createProject() {
		log.info("project created at: {}", LocalDateTime.now());
		return "created";
	}
}
