module PatientHelper
  def start_date(medication)
    Date.strptime(medication["StartDate"], '%Y-%m-%d')
  end
end
