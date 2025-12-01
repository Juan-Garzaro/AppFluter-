const db = require('../config/db');
const bcrypt = require('bcryptjs');

// Registrar usuario
exports.register = (req, res) => {
  const { name, age, email, password } = req.body;

  if (!name || !age || !email || !password) {
    return res.status(400).json({ message: "Todos los campos son obligatorios" });
  }

  const password_hash = bcrypt.hashSync(password, 10);

  const query = `
    INSERT INTO users (name, age, email, password_hash)
    VALUES (?, ?, ?, ?)
  `;

  db.run(query, [name, age, email, password_hash], function (err) {
    if (err) {
      return res.status(500).json({ message: "Error al registrar usuario", error: err });
    }

    res.json({
      message: "Usuario registrado correctamente",
      user: {
        id: this.lastID,
        name,
        age,
        email
      }
    });
  });
};

// Login
exports.login = (req, res) => {
  const { email, password } = req.body;

  db.get(`SELECT * FROM users WHERE email = ?`, [email], (err, user) => {
    if (err || !user) {
      return res.status(400).json({ message: "Correo o contraseña incorrectos" });
    }

    const passwordMatch = bcrypt.compareSync(password, user.password_hash);
    if (!passwordMatch) {
      return res.status(400).json({ message: "Correo o contraseña incorrectos" });
    }

    res.json({
      message: "Login exitoso",
      user: {
        id: user.id,
        name: user.name,
        age: user.age,
        email: user.email,
        profile_image: user.profile_image
      }
    });
  });
};
