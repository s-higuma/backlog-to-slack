# Description:
#   Backlog to Slack
#
# Commands:
#   None

backlogUrl = 'https://mobileclip.backlog.jp/'

module.exports = (robot) ->
  robot.router.post "/room/:room", (req, res) ->
    room = req.params.room
    body = req.body

    console.log 'body type = ' + body.type
    console.log 'room = ' + room

    try
      switch body.type
          when 1
              label = '�ۑ�̒ǉ�'
          when 2, 3
              # �u�X�V�v�Ɓu�R�����g�v�͎��ۂ͈ꏏ�Ɏg���̂ŁA�ꏏ�ɁB
              label = '�ۑ�̍X�V'
          else
              # �ۑ�֘A�ȊO�̓X���[
              return

      # ���e���b�Z�[�W�𐮌`
      url = "#{backlogUrl}view/#{body.project.projectKey}-#{body.content.key_id}"
      if body.content.comment?.id?
          url += "#comment-#{body.content.comment.id}"

      message = "*Backlog #{label}*\n"
      message += "[#{body.project.projectKey}-#{body.content.key_id}] - "
      message += "#{body.content.summary} _by #{body.createdUser.name}_\n>>> "
      if body.content.comment?.content?
          message += "#{body.content.comment.content}\n"
      message += "#{url}"

      console.log 'message = ' + message
      # Slack �ɓ��e
      if message?
          robot.messageRoom room, message
          res.end "OK"
      else
          robot.messageRoom room, "Backlog integration error."
          res.end "Error"
    catch error
      robot.send
      res.end "Error"