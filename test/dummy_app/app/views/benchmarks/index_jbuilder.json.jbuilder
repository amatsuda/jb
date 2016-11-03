# frozen_string_literal: true
json.comments do
  json.partial! 'comment_jbuilder', collection: @comments, as: 'comment'
end
