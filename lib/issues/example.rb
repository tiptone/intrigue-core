module Intrigue
module Issue
class Example < Intrigue::Model::Issue

  def self.metadata
    {
      name: "example",
      pretty_name: "Just an Example Issue",
      severity: 1,
      category: "network",
      description: "This example issue is terrible and you should drop everything to fix it!",
      remediation: "No patch is currently available, and only screaming seems to help.",
      affected: [ "Every version of everything" ],
      references: [
        { type: "vulnerability", uri: "https://allabouttheexamplevulnerability.com" },
        { type: "remediation", uri: "https://www.youtube.com/watch?v=FDv566DSTKg" }
      ]
    }
  end

end
end
end


        