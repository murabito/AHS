module PatientHelper
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
    allergy["Severity"]["Name"].titlecase || 'Severity is unavailable'
  end

  def allergy_status(allergy)
    allergy["Status"]["Name"].titlecase || 'Status is unavailable'
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

  def status(medication)
    return 'Status is unavailable' if medication["EndDate"].blank?

    end_date = Date.strptime(formatted_date(medication["EndDate"]))
    
    if DateTime.now <= end_date
      return 'Active'
    else
      return 'Inactive'
    end
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
