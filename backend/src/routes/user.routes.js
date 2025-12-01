const express = require("express");
const router = express.Router();
const userController = require("../controllers/user.controller");

// Obtener usuario por ID
router.get("/:id", userController.getUserById);

// Actualizar imagen
router.put("/:id/profile-image", userController.updateProfileImage);

module.exports = router;
