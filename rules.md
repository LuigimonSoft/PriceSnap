# AI Development Rules

1. **Run tests after every change**
   - After each code change, the full relevant test suite must be executed before considering the task complete.

2. **Test naming convention is mandatory**
   - Every test method must follow this exact naming style:
   - `GivenXXX_WhenYYY_ThenZZZ_Should_MMM`

3. **Minimum coverage requirement**
   - Test coverage must be at least **80%**.

4. **Test folder structure**
   - All tests must be located inside the `test` folder.
   - Inside `test`, tests must be organized in these subfolders:
     - `repository`
     - `service`
     - `application`
