module PatientHelper
  def toggle_saved_view_text(summary_id)
    recent_view = RecentView.where(clinical_summary_id: summary_id).where(user_id: current_user.id).first
    
    return if !recent_view
    
    if recent_view.is_saved
      'Remove From Saved Views'
    else
      'Save This Clinical Summary'
    end
  end

  def substance_name(allergy)
    allergy["Substance"]["Name"].titlecase || ''
  end

  def reaction(allergy)
    reaction_list = ''
    reactions_array = allergy["Reaction"]

    return 'Reaction is unavailable' if reactions_array.empty?

    if reactions_array.count == 1
      reaction_list = reactions_array.first["Name"]
    else
      reactions = []
      reactions_array.each do | reaction | 
        reactions << reaction["Name"]
      end
      reaction_list = reactions.join(', ')
    end

    reaction_list
  end

  def severity(allergy)
    return 'Severity is unavailable' if allergy["Severity"]["Name"].blank?
    allergy["Severity"]["Name"].titlecase
  end

  def allergy_status(allergy)
    return 'Status is unavailable' if allergy["Status"]["Name"].blank?
    allergy["Status"]["Name"].titlecase
  end

  def reason_for_visit(encounter)
    binding.pry
    return 'Reason for visit is unavailable' if encounter["ReasonForVisit"].blank?

    if encounter["ReasonForVisit"].count == 1
      return encounter["ReasonForVisit"].first["Name"]
    else
      reason_list = []
      encounter["ReasonForVisit"].each do | reason |
        reason_list << reason["Name"]
      end
    end
    reason_list.join(', ')
  end

  def performer(encounter)
    return 'Unavailable' if encounter["Providers"].blank?

    if encounter["Providers"].count == 1
      return encounter["Providers"].first["Role"]["Name"]
    else
      performer_list = []
      encounter["Providers"].each do | provider |
        performer_list << provider["Role"]["Name"]
      end
    end
    performer_list.join(', ')
  end

  def age_at_onset(problem)
    return 'Unavailable'if problem["AgeAtOnset"].blank?
    problem["AgeAtOnset"]
  end

  def formatted_date(date)
    return '' if date.blank?
    Date.strptime(date, '%Y-%m-%d').to_s
  end

  def effective_date_str(start_date, end_date)
    start_date = formatted_date(start_date)
    end_date = formatted_date(end_date)
    
    if start_date.empty? && end_date.empty?
      effective_dates = 'Unavailable'
    elsif start_date.empty?
      effective_dates = 'Unavailable' + ' -- ' + end_date
    elsif end_date.empty?
      effective_dates = start_date + ' -- ' + 'Unavailable'
    else
      effective_dates = start_date + ' -- ' + end_date
    end
    effective_dates
  end

  def product_name(data)
    return '' if data["Product"]["Name"].blank?
    data["Product"]["Name"].capitalize
  end

  def directions(medication)
    return '' if medication["FreeTextSig"].blank?
    medication["FreeTextSig"].capitalize
  end

  def status(medication)
    return 'Status is unavailable' if medication["EndDate"].blank?

    end_date = Date.strptime(formatted_date(medication["EndDate"]))
    
    if DateTime.now <= end_date
      return 'Active'
    else
      return 'Inactive'
    end
  end

  def formatted_name_str(data)
    return '' if data["Name"].blank?
    data["Name"].capitalize
  end

  def formatted_status_str(problem)
    return 'Status is unavailable' if problem["Status"]["Name"].blank?
    problem["Status"]["Name"].capitalize
  end

  def result_value_str(observation)
    return 'Result is unavailable' if observation["Value"].empty?
    observation["Value"] + ' ' + observation["Units"] 
  end

  def height(vital_sign_group)
    observations = vital_sign_group["Observations"]
    height = observations.select { | vital_sign | vital_sign["Code"] == "8302-2" }.first

    return '' if !height
    height["Value"] + ' ' + height["Units"]
  end

  def weight(vital_sign_group)
    observations = vital_sign_group["Observations"]
    weight = observations.select { | vital_sign | vital_sign["Code"] == "3141-9" }.first

    return '' if !weight
    weight["Value"] + ' ' + weight["Units"]
  end

  def blood_pressure(vital_sign_group)
    observations = vital_sign_group["Observations"]
    top = observations.select { | vital_sign | vital_sign["Code"] == "8480-6" }.first
    bottom = observations.select { | vital_sign | vital_sign["Code"] == "8462-4" }.first

    return '' if !(top && bottom)
    top["Value"] + '/' + bottom["Value"] + ' ' + bottom["Units"]
  end
end
