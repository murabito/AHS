module PatientHelper
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
    height_data = observations.select { | vital_sign | vital_sign["Code"] == "8302-2" }.first

    return '' if !height_data
    height_data["Value"] + ' ' + height_data["Units"]
  end

  def weight(vital_sign_group)
    observations = vital_sign_group["Observations"]
    weight_data = observations.select { | vital_sign | vital_sign["Code"] == "3141-9" }.first

    return '' if !weight_data
    weight_data["Value"] + ' ' + weight_data["Units"]
  end
end



















