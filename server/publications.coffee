Meteor.publish("adminGroups", ()->
  user = Meteor.users.findOne(this.userId)
  return Groups.find({admins: if user?.profile?.netId? then user.profile.netId else "" })
)
Meteor.publish("adminElections", ()->
  user = Meteor.users.findOne(this.userId)
  groups = Groups.
    find({admins: if user?.profile?.netId? then user.profile.netId else ""}).fetch()
  return Elections.find(
    groups:{$in: if groups.length > 0 then _.map(groups, (g) -> g._id) else []}
    )
)
Meteor.publish("Elections", () ->
  user = Meteor.users.findOne(this.userId)
  groups = Groups.
    find({netIds: if user?.profile?.netId? then user.profile.netId else ""}).fetch()
  return Elections.find(
    groups:
      {$in: if groups.length > 0 then _.map(groups, (g) -> g._id) else []}
    status:"open",
    voters: {$ne: if user?.profile?.netId? then user.profile.netId else ""},
    {fields: {voters: 0}})
)
