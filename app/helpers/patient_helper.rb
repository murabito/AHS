module PatientHelper
  def age_at_onset(problem)
    return 'Unavailable'if problem["AgeAtOnset"].blank?
    problem["AgeAtOnset"]
  end

  def start_date(medication)
    Date.strptime(medication["StartDate"], '%Y-%m-%d')
  end

  def end_date(medication)
    Date.strptime(medication["EndDate"], '%Y-%m-%d') if !!medication["EndDate"]
  end

  def status(medication)
    if end_date(medication).blank?
      return 'Status is unavailable'
    elsif DateTime.now <= end_date(medication)
      return 'Active'
    else
      return 'Inactive'
    end
  end
end
