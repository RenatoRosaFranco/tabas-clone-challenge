# frozen_string_literal: true

module AttachablePhotos
  extend ActiveSupport::Concern

  private

  def attach_files!(record, attachment_name, files)
    return if files.blank?
    record.public_send(attachment_name).attach(files)
  end

  def purge_attachments!(record, attachment_name, ids)
    return if ids.blank?

    Array(ids).each do |attachment_id|
      record.public_send(attachment_name).attachments.find_by(id: attachment_id)&.purge
    end
  end
end
