require 'initialize'

# Create `window.describe` etc. for our BDD-like tests.
mocha.setup ui: 'bdd'

# Create global variables for simpler syntax.
window.expect = chai.expect

# Chai bugfix github.com/chaijs/chai/issues/107
window.should = undefined
window.should = chai.should()

# require tests
$ ->
  window.require.list()
    .filter((_) -> /-test$/.test(_))
    .forEach(require)
