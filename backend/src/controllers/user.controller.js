const db = require("../config/db");

// Obtener usuario por ID
exports.getUserById = (req, res) => {
  const { id } = req.params;

  const query = "SELECT id, name, age, email, profile_image, created_at FROM users WHERE id = ?";

  db.get(query, [id], (err, row) => {
    if (err) {
      console.log("Error SQL:", err);
      return res.status(500).json({ message: "Error al obtener usuario" });
    }

    if (!row) {
      return res.status(404).json({ message: "Usuario no encontrado" });
    }

    res.json(row);
  });
};

// Actualizar imagen de perfil
exports.updateProfileImage = (req, res) => {
  const { id } = req.params;
  const { profile_image } = req.body;

  if (!profile_image) {
    return res.status(400).json({ message: "Falta la imagen" });
  }

  const query = `
    UPDATE users
    SET profile_image = ?
    WHERE id = ?
  `;

  db.run(query, [profile_image, id], function (err) {
    if (err) {
      console.log("Error SQL:", err);
      return res.status(500).json({
        message: "Error al actualizar imagen",
        error: err,
      });
    }

    res.json({ message: "Imagen actualizada correctamente" });
  });
};
