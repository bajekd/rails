class MetadataJob < ApplicationJob
  def perform(code)
    link = Link.find_by_short_code(code)
    link.update(Metadata.retrive_from(link.url).attributes)
    link.broadcast_replace_to(link)
  end
end
