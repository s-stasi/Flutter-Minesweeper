import 'dart:developer';

class Matrix<T> extends Iterable<T> {
  final int rows;
  final int cols;
  final List<List<T>> _data;

  Matrix(this.rows, this.cols, T Function(int, int) initializer)
      : _data = List.generate(
            rows, (i) => List.generate(cols, (j) => initializer(i, j)));

  // Access element at (i, j)
  T operator [](List<int> pos) => _data[pos[0]][pos[1]];

  // Set element at (i, j)
  void operator []=(List<int> pos, T value) {
    _data[pos[0]][pos[1]] = value;
  }

  // Get the row at index i
  List<T> row(int i) => _data[i];

  // Get the column at index j
  List<T> col(int j) => List.generate(rows, (i) => _data[i][j]);

  // Print the matrix
  void printMatrix() {
    for (var row in _data) {
      log(row.toString());
    }
  }

  @override
  Iterator<T> get iterator => _MatrixIterator<T>(this);
}

class _MatrixIterator<T> implements Iterator<T> {
  final Matrix<T> matrix;
  int _currentRow = 0;
  int _currentCol = -1;

  _MatrixIterator(this.matrix);

  @override
  bool moveNext() {
    if (_currentCol < matrix.cols - 1) {
      _currentCol++;
    } else if (_currentRow < matrix.rows - 1) {
      _currentRow++;
      _currentCol = 0;
    } else {
      return false;
    }
    return true;
  }

  @override
  T get current => matrix._data[_currentRow][_currentCol];
}
