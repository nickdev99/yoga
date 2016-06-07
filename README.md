# YogaSite (aka iliveyoga.ca)

Hello, welcome to yogasite.

## Plugins

Currently, none.

## Gems

See Gemfile. No important notes.

## Documentation

Some documentation uses YARD: http://yardoc.org/ and http://rubydoc.info/docs/yard/file/README.md

## Specs

See the /specs folder for test coverage.

## Structure

The hierarchical structure for providers and classes is roughly as follows:

	- Providers: organisations providing
	- Studios: particular locations where yoga classes happen. Belong to providers
	- Courses: sets of yoga classes (eg recurring Wednesday course, single day course next Friday). Belong to Studios.
	- CourseOccurrences: single occurences of a course (eg next Wednesday's yoga class)
	
Most yoga class attributes are set on either Course or CourseOccurrence: class name, for example, is set on Courses; staff assignments (instructors etc) are set on particular CourseOccurrences.

## Deployment

Via capistrano.
Staging (http://dev.iliveyoga.ca)
    `cap staging deploy`

Production (http://iliveyoga.ca) 
    `cap production deploy`

## Issues

One issue: Rails' layout with proc isn't working with Rails 3.0.4, so we can't use:

	class SomeController
		layout proc { request.xhr? ? false : 'application' }
	end

## Previous Developers

James Wilding (office@jameswilding.net)