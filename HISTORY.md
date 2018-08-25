# 0.2.0
## Breaking changes

LibSVMLoader has been modified to return the samples and labels of dataset as Ruby Array.
Thus, LibSVMLoader does not require NMatrix.

# 0.1.3
- Changed the visibility of protected methods to the private.
- Fixed the description in the gemspec file.

# 0.1.2
- Changed the way to read a file.

# 0.1.1
- Fixed to fail reading zero vectors.

# 0.1.0
- Added basic class.
- Added the methods that read and write a file with libsvm format.
