Data = new Meteor.Collection "data"

if Meteor.isClient
	Router.configure
		layoutTemplate: "layout"

	Router.map ->
		@route "route",
			path: "/"
			controller: "SubRouteController"

	class @BaseRouteController extends RouteController
		before: ->
			console.log "base.before"
			@subscribe("data").wait()

		data: ->
			if not @ready()
				@stop()
				return
				
			Data.find({}).fetch()

		after: ->
			console.log "base.after"

	class @SubRouteController extends BaseRouteController
		template: "route"

	Template.route.serializeData = ->
		JSON.stringify(this)

else if Meteor.isServer
	Meteor.publish "data", ->
		self = this
		@added "data", "1", 
			data: "data"

		@onStop ->
			self.removed "data", "1"

		@ready()