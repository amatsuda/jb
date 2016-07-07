@<%= plural_table_name %>.map do |<%= singular_table_name %>|
  {
<% attributes_names.each do |attr| -%>
    <%= attr %>: <%= singular_table_name %>.<%= attr %>,
<% end -%>
    url: <%= singular_table_name %>_url(<%= singular_table_name %>, format: :json)
  }
end
