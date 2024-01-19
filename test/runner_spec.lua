local runner = require('quick-code-runner.main')

describe('quick-code-runner plugin', function()
  it('should be able to load', function()
    assert.truthy(runner)
  end)
end)
