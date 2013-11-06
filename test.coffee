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

	class @SubRouteController extends BaseRouteController
		template: "route"
		data: ->
			if not @ready()
				@stop()
				return

			Data.find({}).fetch()

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