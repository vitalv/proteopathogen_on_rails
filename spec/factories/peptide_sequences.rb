
FactoryGirl.define do
  factory :peptide_sequence do |f|
    sequence(:sequence) { "#{(0...rand(50)+10).map{ ('A'..'Z').to_a[rand(26)] }.join}" } 
        
  end
  
end

